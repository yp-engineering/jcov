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

      options.args = args

      config = JCov::Configuration.new(options.config)

      runner = JCov::Runner.new(config, options)

      runner.run

      abort "Test Failures! :(" if runner.failure_count > 0

      if options.report
        JCov::Reporter::HTMLReporter.new(runner.coverage).report
      end

      reporter = JCov::Reporter::ConsoleReporter.new(runner.coverage)

      abort unless reporter.report
    end
  end

end
