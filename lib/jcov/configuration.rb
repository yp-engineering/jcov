require 'yaml'

module JCov
  class Configuration

    LOCATIONS = %w{config/jcov.yml ./jcov.yml}

    attr_reader :config
    attr_reader :filename

    DEFAULTS = {
      "test_directory"          => "test/javascripts",
      "source_directory"        => "public/javascripts",
      "test_runner"             => "test/javascripts/runner.js",
      "error_field"             => "error_count",
      "report_output_directory" => "jcov",
      "verbose"                 => false,
      "color"                   => true,
      "coverage"                => true,
      "report"                  => false,
      "dump"                    => false
    }

    def initialize(options)
      @filename = find_file(options.config)
      @config = DEFAULTS.merge(options.__hash__)
      @config.merge!(YAML.load_file(@filename)) if @filename
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
