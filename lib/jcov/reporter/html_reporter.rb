require 'erb'
require 'fileutils'
require 'json'

module JCov::Reporter

  class HTMLReporter

    def initialize coverage_runner
      @coverage_runner = coverage_runner
    end

    def report
      template = File.read File.expand_path('../report.html.erb', __FILE__)
      erb = ERB.new(template)
      out = erb.result(@coverage_runner.get_binding)

      output_dir = @coverage_runner.config.report_output_directory
      FileUtils.mkdir_p output_dir

      filename = File.join(output_dir, "report.html")
      File.open(filename, "w") { |io| io.write out }
    end

  end

end
