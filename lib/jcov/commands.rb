require 'yaml'

module JCov::Commands

  # the check command
  class Check
    def initialize args, options
      puts JCov::Configuration.new options.config
    end
  end

  # the run command
  class Run
    def initialize args, options
      # default to no color unless we're on a tty
      options.default :color => $stdout.tty?

      config = JCov::Configuration.new options.config

      runner = JCov::Runner.new(config, options)
      
      runner.run

      abort("Test Failures! :(") if runner.failure_count > 0
    end
  end

end
