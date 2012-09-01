module JCov::Reporter

  class ConsoleReporter

    attr_accessor :total_count, :covered_count, :percent

    def initialize coverage_runner
      @coverage_runner = coverage_runner

      calculate_total_coverage if report_coverage?
    end

    def report
      if total_count && total_count == 0
        # report a warning message if we're not checking any files for coverage
        puts "No files were checked for coverage. Maybe your ignore list in #{config.filename} is too inclusive?"
      elsif report_coverage?
        report_file_coverage    if options.report
        report_total_coverage
        report_threshold_errors if config.threshold
      end
      passed?
    end

    private

    def config
      @coverage_runner.config
    end

    def options
      @coverage_runner.options
    end

    def report_coverage?
      options.report || options.coverage && options.test.nil? && options.args.empty?
    end

    # passes if any are true:
    # 1. we're not checking a threshold
    # 2. thresholds must match and they do
    # 3. coverage percent is greater than or equal to threshold
    def passed?
      config.threshold.nil? ||
      (config.threshold_must_match && percent == config.threshold) ||
      percent >= config.threshold
    end

    # report an under threshold error
    # report an over threshold error if threshold_must_match is set to true
    def report_threshold_errors
      if percent < config.threshold
        puts "FAIL! Coverage is lower than threshold! #{percent}% < #{config.threshold}% :("
      elsif config.threshold_must_match && percent != config.threshold
        puts "Coverage does not match threshold! #{percent}% != #{config.threshold}%"
        puts "Please raise the threshold in #{config.filename}"
      end
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
