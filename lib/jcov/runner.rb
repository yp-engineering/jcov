module JCov

  class Runner
    attr_reader :config
    attr_reader :options
    attr_reader :coverage

    def initialize(config, options)
      @config  = config
      @options = options
    end

    # which tests shall we run?
    def tests
      if @tests.nil?
        if options.args.size > 0
          @tests = options.args
        else
          @tests = Dir.glob(File.join(config.test_directory, "**", "*.js"))
        end
        if options.test # limit to a single or group of tests
          @tests = @tests.grep(/#{options.test}/)
        end
        # remove the runner if it's in there
        @tests.delete(config.test_runner)
        @tests.sort!
      end
      @tests
    end

    def failure_count
      @context.eval(config.error_field)
    end

    def run
      setup

      @context.load(config.test_runner)

      failure_count
    end

  private

    def setup
      # for coverage reporting
      @coverage = JCov::Coverage.new(config, options)

      # v8 context for running
      run_context = JCov::Context::RunContext.new(@coverage.loader)
      @context = run_context.create

      # create the jcov context object
      @context['JCov'] = {}
      @context['JCov']['tests']   = tests
      @context['JCov']['config']  = config
      @context['JCov']['options'] = options.__hash__
    end

  end

end
