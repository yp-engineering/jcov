require 'yaml'

module JCov
  class Configuration

    LOCATIONS = %w{config/jcov.yml ./jcov.yml}

    attr_reader :config

    DEFAULTS = {
      "test_directory"   => "test/javascripts",
      "source_directory" => "public/javascripts",
      "test_runner"      => "test/javascripts/runner.js",
      "error_field"      => "error_count"
    }

    def initialize file
      @config_filename = find_file(file)
      @config = DEFAULTS.merge(@config_filename && YAML.load_file(@config_filename) || {})
      create_readers
    end

    def to_s
      @config.to_yaml
    end

    # ignore unset configuration values
    def method_missing method
      nil
    end

    private

    def find_file file
      raise "Cannot find file \"#{file}\"" if file && !File.exists?(file)

      file || LOCATIONS.find do |file|
                File.exists?(file)
              end
    end

    # create methods to access the configuration
    def create_readers
      @config.each_key do |key|
        self.class.send(:define_method, key) do
          @config[key]
        end
      end
    end
    
  end
end
