require 'erb'
require 'fileutils'
require 'json'
require 'cgi'

module JCov::Reporter

  class HTMLReporter

    def initialize(coverage_runner)
      @coverage_runner = coverage_runner

      @report_index_template = File.read File.expand_path('../report.html.erb', __FILE__)
      @report_file_template  = File.read File.expand_path('../file.html.erb', __FILE__)
    end

    def report
      make_output_dir
      render_index
      render_files
      copy_css
    end

    private

    def make_output_dir
      FileUtils.mkdir_p output_dir
    end

    def render_index
      erb = ERB.new(@report_index_template)
      out = erb.result(@coverage_runner.get_binding)

      filename = File.join(output_dir, "report.html")
      File.open(filename, "w") { |io| io.write out }
    end

    def render_files
      @coverage_runner.reduced_coverage_data.each do |filename, total_line_count, covered_line_count|

        content = File.read(filename)
        coverage = @coverage_runner.coverage_data[filename]

        erb = ERB.new(@report_file_template)
        out = erb.result(binding)

        FileUtils.mkdir_p File.join(output_dir, File.dirname(filename))

        filename = File.join(output_dir, filename) << ".html"
        File.open(filename, "w") { |io| io.write out }
      end
    end

    def copy_css
      FileUtils.cp File.expand_path('../report.css', __FILE__), output_dir
    end

    def output_dir
      @coverage_runner.config.report_output_directory
    end

  end

end
