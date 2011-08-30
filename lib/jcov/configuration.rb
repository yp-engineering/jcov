require 'yaml'

module JCov
  class Configuration

    LOCATIONS = %w{config/jcov.yml ./jcov.yml}

    attr_reader :config

    DEFAULTS = {
      source_file_directory: "public/javascripts"
    }

    def initialize file
      @config_filename = find_file(file)
      @config = DEFAULTS.merge(@config_filename && YAML.load_file(@config_filename) || {})
    end

    def to_s
      @config.to_yaml
    end

    private

    def find_file file
      if file && File.exists?(file)
	file
      else
	LOCATIONS.find do |file|
	  File.exists?(file)
	end
      end
    end
    
  end
end
