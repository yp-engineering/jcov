module JCov::Context
    
  class RunContext
    include JCov::Context

    def initialize(loader)
      @loader = loader
      @coverage_data = loader.coverage_data
    end

    def print(s)
      Kernel.print s
    end

    def println(*s)
      Kernel.puts s
    end

    # so we can do our dotted line output
    def putc(char)
      $stdout.putc(char);
      $stdout.flush();
    end

    # for JSpec
    def readFile(file)
      File.read(file)
    end

    def load(file)
      # use the configured loader
      content = @loader.load file

      # evaluate the javascript
      @context.eval(content, file)
    end

    # increment
    def _coverage_tick(file, line)
      @coverage_data[file][line] += 1
    end
  end

end
