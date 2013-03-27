module JCov

  class Loader

    attr_accessor :coverable_files

    def initialize(coverable_files, options={})
      @options = options
      @coverable_files = coverable_files
      @file_cache = {}

      create_parser
    end

    def load(file)
      if @file_cache[file]
        # reuse previously loaded file
        content = @file_cache[file]
      else
        content = File.read(file)

        # is this a file we need to instrument?
        if coverable_files.include? file

          # run it through the js parser to get coverage data
          calculate_coverage_data file, content

          # update the content with the coverage instrumentations
          content = instrument_script(content, file)

          # cache the file if it's reloaded
          @file_cache[file] = content
        end
      end

      content
    end

    def coverage_data
      if @coverage_data.nil?
        # set up coverage data structure
        @coverage_data = {}
        coverable_files.each {|file| @coverage_data[file] = {} }
      end
      @coverage_data
    end

  private

    def create_parser
      context = JCov::Context::InstrumentationContext.new(coverage_data)
      @parser = context.create

      @parser.load(File.expand_path('../js/parser.js', __FILE__))
      @parser.load(File.expand_path('../../../vendor/acorn.js', __FILE__))
      @parser.load(File.expand_path('../../../vendor/walk.js', __FILE__))
    end

    def instrument_script(content, filename)
      lines = coverage_data[filename] || {}
      line_number = 0
      output = ""

      StringIO.new(content).each_line do |line|
        line_number += 1
        if !lines[line_number].nil? # nil values are ones set to be ignored by ignoreLine
          column = lines[line_number]
          output << line[0...column]
          output << "_coverage_tick('#{filename}', #{line_number});"
          output << line[column..-1]
          lines[line_number] = 0 # reset to zero for counting
        else
          output << line
        end
      end

      puts output if @options[:dump]

      output
    end

    def calculate_coverage_data(filename, content)
      @parser['filename'] = filename
      @parser['code']     = content
      @parser.eval("JCov.calculateCoverageData(code, filename);")
    rescue V8::Error => e
      message = e.message.split(' at').first
      raise JCov::ParseError.new("#{message} in #{filename}")
    end
  end

end
