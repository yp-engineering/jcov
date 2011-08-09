module JCov
  module Coverage

    # extend RKelly's ECMAVisitor to include our coverage_tick
    class CoverageVisitor < RKelly::Visitors::ECMAVisitor
      def initialize(coverage)
        @coverage = coverage
        @indent = 0
      end

      # whenever we hit a line, add the instrumentation
      def visit_SourceElementsNode(o)
        o.value.map { |x|
          if (x.filename && x.line)
            coverage = "_coverage_tick('#{x.filename}', #{x.line});"
            @coverage[x.filename][x.line] = 0
          end
          "#{coverage || ""}#{indent}#{x.accept(self)}"
        }.join("\n")
      end
    end


    class CoverageRunner
      attr_accessor :config
      attr_accessor :config_file
      attr_accessor :runner
      attr_accessor :instrumented_files

      def initialize config={}
        @config = config

        @runner = JSpec::Runner.new(config)

        load_config_file
        override_runners_load_method
        add_coverage_method_to_context

        @visitor = CoverageVisitor.new(coverage_data)
        @parser  = RKelly::Parser.new

        @instrumented_files = {}
      end

      def load_config_file
        @config_file = YAML.load_file(File.join(Rails.root, "jspec", "jcov.yml"))
      end

      def coverable_files
        if @coverable_files.nil?
          # find all the files we're testing on
          @coverable_files = Dir.glob(File.join("public", "javascripts", "**", "*.js"))
          # only run coverage on files that we haven't specifically ignored
          ignore = config_file['ignore']
          @coverable_files.delete_if {|file| ignore.any? {|i| file.match(i) }}
        end
        @coverable_files
      end

      def coverage_data
        if @coverage_data.nil?
          # set up coverage data structure
          @coverage_data = {}
          coverable_files.each {|file| @coverage_data[file] = {} }
        end
        @coverage_data
      end

      # our new load method
      def load file
        if instrumented_files[file]
          # reuse previously loaded file
          content = instrumented_files[file]
        else
          content = File.read(file)

          # is this a file we need to instrument?
          if coverable_files.include? file
            # run it through the js parser and custom renderer
            tree    = @parser.parse(content, file)
            content = @visitor.accept(tree)

            # cache the file if it's reloaded
            instrumented_files[file] = content
          end
        end

        runner.context.eval(content, file)
      end

      def _coverage_tick file, line
        coverage_data[file][line] += 1
      end

      def run
        runner.run

        coverage_report if config[:report] || config[:test]

        coverage_total
      end

      # proxy to runner
      def failure_count
        runner.failure_count
      end

      # reduce the coverage data to file, total line count, and covered line count
      def reduced_coverage_data
        if @reduced_coverage_data.nil?
          @reduced_coverage_data = coverage_data.map do |file, lines|
            # if we don't have any data for this file it was never loaded
            if lines.empty?
              # load it now
              content = File.read(file)

              # run it through the js parser and custom renderer
              # the visitor will fill out the coverage data for this line
              tree    = @parser.parse(content, file)
              content = @visitor.accept(tree)

              # re-get the lines
              lines = coverage_data[file]

              # this file was never run
              cover = 0
            else
              # munge the count data together to get coverage
              cover = lines.values.inject(0) { |memo, count| memo + ((count > 0) ? 1 : 0) }
            end

            total = lines.count

            [file, total, cover]
          end
        end
        @reduced_coverage_data
      end

      def coverage_report
        puts "\n"

        puts "Coverage Report"
        puts "===================="

        filename_length = coverage_data.map(&:first).map(&:length).max

        reduced_coverage_data.each do |file, total, cover|
          if (total > 0)
            percent = 100 * cover / total
            coverage_string = "(#{cover}/#{total})"
          else
            percent = 100
            coverage_string = "(EMPTY)"
          end
          if !config[:test] || percent > 0 # only show ran files if we're doing a focused test
            printf "%-#{filename_length}s %-10s %3s%\n", file, coverage_string, percent
          end
        end
        puts "===================="
      end

      def coverage_total
        total   = 0
        covered = 0

        reduced_coverage_data.each do |file, tot, cover|
          if !config[:test] || cover > 0 # only show ran files if we're doing a focused test
            total += tot
            covered += cover
          end
        end

        # only keep one significant digit
        percent = (100.0 * covered / total).round(1)
        printf "\nTotal Coverage: (%d/%d) %3.1f%\n\n", covered, total, percent

        percent
      end

    private

      def add_coverage_method_to_context
        runner.context['_coverage_tick'] = self.method('_coverage_tick')
      end

      def override_runners_load_method
        runner.context['load'] = self.method('load')
      end

    end

  end
end
