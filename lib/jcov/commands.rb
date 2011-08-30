require 'yaml'

module JCov::Commands

  class Check
    def initialize args, options
      puts JCov::Configuration.new options.config
    end
  end

end
