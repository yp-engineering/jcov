module JCov::Reporter

  class ConsoleReporter

    attr_accessor :total_count, :covered_count, :percent

    def initialize coverage_runner
      @coverage_runner = coverage_runner

      calculate_total_coverage
    end

    def report
      report_total_coverage if total_count > 0
      report_error_messages
    end

    private

    def report_error_messages
      options = @coverage_runner.options
      config  = @coverage_runner.config

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
        if !@coverage_runner.config.test || percent > 0 # only show ran files if we're doing a focused test
          printf "%-#{filename_length}s %-10s %3s%\n", file, coverage_string, percent
        end
      end
      puts "===================="
    end

    def calculate_total_coverage
      @total_count   = 0
      @covered_count = 0

      @coverage_runner.reduced_coverage_data.each do |file, tot, cover|
        if !@coverage_runner.config.test || cover > 0 # only show ran files if we're doing a focused test
          @total_count   += tot
          @covered_count += cover
        end
      end

      # only keep one significant digit
      @percent = (100.0 * @covered_count / @total_count).round(1)
    end

  end

end
