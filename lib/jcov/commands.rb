require 'yaml'

module JCov::Commands

  class Check
    def initialize args, options
      config = options.config || 'config/jcov.yml'
      if File.exist? config
        @config_file = YAML.load_file(config)
        puts @config_file.to_yaml
      else
        puts "Cannot find configuration file #{config}"
      end
    end
  end

end
