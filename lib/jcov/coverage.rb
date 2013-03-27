module JCov

  class Coverage

    attr_accessor :loader
    attr_accessor :config

    def initialize(config)
      @config = config

      # for loading and instrumenting fiels
      @loader = JCov::Loader.new(coverable_files, :dump => config.dump)
    end

    def coverable_files
      if @coverable_files.nil?
        # all the files we're testing on
        @coverable_files = Dir.glob(File.join(@config.source_directory, "**", "*.js"))
        # only run coverage on files that we haven't specifically ignored
        ignore = @config.ignore || []
        @coverable_files.delete_if {|file| ignore.any? {|i| file.match(i) }}
        # remove the runner if it's in there
        @coverable_files.delete(@config.test_runner)
      end
      @coverable_files
    end

    # reduce the coverage data to file, total line count, and covered line count
    def reduced_coverage_data
      # cache the result
      @reduced_coverage_data ||=
        coverage_data.map do |file, lines|
          # if we don't have any data for this file it was never loaded
          if lines.empty?
            # load it now
            lines = examine_uncovered_file file

            # this file was never run so it has zero coverage
            cover = 0
          else
            # munge the count data together to get coverage
            cover = lines.values.compact.inject(0) { |memo, count| memo + ((count > 0) ? 1 : 0) }
          end

          # ignore nil values
          total = lines.values.compact.count

          [file, total, cover]
        end
    end

    def coverage_data
      @loader.coverage_data
    end

    # for coverage reporting
    def get_binding
      binding
    end

  private

    # when a file is in the list to be examined but never loaded
    # we have to load it ourselves to calculate the full coverage counts
    def examine_uncovered_file(filename)
      # run it through the Loader
      # it will fill out the coverage data for this file
      @loader.load filename

      # re-get the lines
      coverage_data[filename]
    end

  end

end
