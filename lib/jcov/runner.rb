module JCov

  class Runner
    attr_reader :context
    attr_reader :config
    attr_reader :options

    def initialize(config, options)
      @config  = config
      @options = options

      setup_context
    end

    def tests
      # which tests shall we run?
      if @tests.nil?
        @tests = Dir.glob(File.join(config.test_directory, "**", "*.js"))
        if options.test # limit to a single or group of tests
          @tests = @tests.grep(/#{options.test}/)
        end
        # remove the runner if it's in there
        @tests.delete(config.test_runner)
        @tests.sort!
      end
      @tests
    end

    def print s
      Kernel.print s
    end

    def println *s
      Kernel.puts s
    end

    def load file
      content = File.read(file)

      context.eval(content, file)
    end

    # for JSpec
    def readFile file
      File.read(file)
    end

    # so we can do our dotted line output
    def putc char
      $stdout.putc(char);
      $stdout.flush();
    end

    def failure_count
      context.eval(config.error_field)
    end

    def run
      context.load(config.test_runner)

      failure_count
    end

  private

    def setup_context
      # create a V8 context for this runner
      @context = V8::Context.new

      # create the jcov context object
      @context["JCov"] = {}

      setup_object_proxies
      setup_method_proxies
    end

    def setup_object_proxies
      context['JCov']['tests']   = tests
      context['JCov']['config']  = config
      context['JCov']['options'] = options.__hash__
    end

    def setup_method_proxies
      # these will become global methods in the context
      %w{print
         println
         load
         readFile
         putc}.each do |method|
        context[method] = self.method(method)
      end
    end

  end

end
