require 'yaml'

module JCov::Commands

  # the check command
  class Check
    def initialize args, options
      config = JCov::Configuration.new options.config

      if config.filename
        puts "Using configuration file: #{config.filename}"
      else
        puts "No configuration file! Using defaults."
      end

      puts config
    end
  end

  # the run command
  class Run
    def initialize args, options
      # default to no color unless we're on a tty
      options.default :color    => $stdout.tty?
      options.default :coverage => true

      config = JCov::Configuration.new options.config

      runner = JCov::Coverage::CoverageRunner.new(config, options)

      percent = runner.run

      abort "Test Failures! :(" if runner.failure_count > 0

      if options.coverage && config.threshold
        if percent < config.threshold
          abort "FAIL! Coverage is lower than threshold! #{percent}% < #{config.threshold}% :("
        elsif config.threshold_must_match && percent != config.threshold
          puts("Coverage does not match threshold! #{percent}% != #{config.threshold}%")
          abort "Please raise the threshold in #{config.filename}"
        end
      end
    end
  end

end
