module JCov::Context
    
  class InstrumentationContext
    include JCov::Context

    def initialize(coverage_data)
      @coverage_data = coverage_data
    end

    # called when a line can be covered by tests
    def lineCovered(file, line, column)
      # only record if the line hasn't been recorded yet
      # or if it has, the line is not flagged with nil
      if !@coverage_data[file].has_key?(line) || !@coverage_data[file].nil?
        @coverage_data[file][line] = column
      end
    end

    # called when a line should be ignored in the coverage report
    def ignoreLine(file, line)
      @coverage_data[file][line] = nil # set to nil so it's ignored
    end

    # for testing
    def print(str)
      puts str
    end

  end

end
