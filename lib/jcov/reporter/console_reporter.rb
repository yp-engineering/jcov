module JCov::Reporter

  class ConsoleReporter

    attr_accessor :total_count, :covered_count, :percent

    def initialize coverage_runner
      @coverage_runner = coverage_runner

      calculate_total_coverage
    end

    def report
      report_total_coverage if options.test.nil? && total_count > 0
      report_file_coverage  if options.report
      report_error_messages
    end

    private

    def config
      @coverage_runner.config
    end

    def options
      @coverage_runner.options
    end

    # don't report anything if we're running a focused test
    # report a warning message if we're not checking any files for coverage
    # report an under threshold error
    # report an over threshold error if threshold_must_match is set to true
    def report_error_messages
      if options.test.nil?
        if options.coverage && total_count == 0
          puts "No files were checked for coverage. Maybe your ignore list in #{config.filename} is too inclusive?"
        elsif options.coverage && config.threshold
          if percent < config.threshold
            puts "FAIL! Coverage is lower than threshold! #{percent}% < #{config.threshold}% :("
            return false
          elsif config.threshold_must_match && percent != config.threshold
            puts "Coverage does not match threshold! #{percent}% != #{config.threshold}%"
            puts "Please raise the threshold in #{config.filename}"
            return false
          end
        end
      end

      true
    end

    def report_total_coverage
      printf "\nTotal Coverage: (%d/%d) %3.1f%\n\n", covered_count, total_count, percent
    end

    def report_file_coverage
      puts "\n"

      puts "Coverage Report"
      puts "===================="

      filename_length = @coverage_runner.coverage_data.map(&:first).map(&:length).max

      @coverage_runner.reduced_coverage_data.each do |file, total, cover|
        if (total > 0)
          percent = 100 * cover / total
          coverage_string = "(#{cover}/#{total})"
        else
          percent = 100
          coverage_string = "(EMPTY)"
        end
        if options.test.nil? || percent > 0 # only show ran files if we're doing a focused test
          printf "%-#{filename_length}s %-10s %3s%\n", file, coverage_string, percent
        end
      end
      puts "===================="
    end

    def calculate_total_coverage
      @total_count   = 0
      @covered_count = 0

      @coverage_runner.reduced_coverage_data.each do |file, tot, cover|
        if !config.test || cover > 0 # only show ran files if we're doing a focused test
          @total_count   += tot
          @covered_count += cover
        end
      end

      # only keep one significant digit
      @percent = (100.0 * @covered_count / @total_count).round(1)
    end

  end

end
