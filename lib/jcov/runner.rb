module JCov

  class Runner
    attr_accessor :context
    attr_accessor :config

    def initialize(config={}, test=nil)
      @config = config
      @test   = test

      setup_context
      setup_method_proxies
    end

    def tests
      # which tests shall we run?
      if @tests.nil?
        @tests = Dir.glob(File.join(config.test_directory, "**", "*.js"))
        if @test # limit to a single or group of tests
          @tests = @tests.grep(/#{@test}/)
        end
        # remove the runner if it's in there
        @tests.delete(config.test_runner)
        @tests.sort!
      end
      @tests
    end

    def print *s
      puts s
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
      # create a new V8 context for this runner
      @context = V8::Context.new

      # pass the environment into the javascript context
      @context["ENV"] = ENV

      # default to no color unless we're on a tty
      ENV['nocolor'] = 'true' unless $stdout.tty?
    end

    def setup_method_proxies
      %w{tests
         print
         load
         readFile
         putc}.each do |method|
        context[method] = self.method(method)
      end
    end

  end

end
