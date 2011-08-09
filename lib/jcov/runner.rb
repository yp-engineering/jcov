module JCov

  class Runner
    attr_accessor :context
    attr_accessor :config

    def initialize(config={})
      @config = config

      setup_context
      setup_method_proxies
    end

    def tests
      # which tests shall we run?
      if @tests.nil?
        @tests = Dir.glob(File.join("jspec", "spec", "**", "*.js"))
        if config[:test] # limit to a single test
          @tests = @tests.grep(/#{config[:test]}/)
        end
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
      context.eval('JSpec.stats.failures;')
    end

    def run
      context.load('jspec/v8.js')

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
