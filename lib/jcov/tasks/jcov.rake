# Rake tasks for running jspec tests

def config
  {
    :test   => ENV['TEST'] || ENV['test'],
    :trace  => !!(ENV['TRACE'] || ENV['trace']),
    :color  => ENV['nocolor'] != 'true',
    :report => !!(ENV['REPORT'] || ENV['report'])
  }
end


desc "Run all the jspec tests"
task :jspec do
  require 'rake/jspec'

  jspec = JSpec::Runner.new(config)

  jspec.run

  abort("JSpec Test Failures! :(") if jspec.failure_count > 0
end


desc "Run all the jspec tests and report coverage"
task :jcov do
  require 'rake/jcov'

  jspec = JSpec::Coverage::CoverageRunner.new(config)

  percent = jspec.run

  abort("JSpec Test Failures! :(") if jspec.failure_count > 0

  if !jspec.config[:test] # don't look at thresholds if we're running a focused test
    threshold = jspec.config_file['threshold']
    abort("FAIL! Coverage is lower than threshold! #{percent}% < #{threshold}% :(") if percent < threshold

    if jspec.config_file['threshold_must_match'] && percent != threshold
      puts("Coverage does not match threshold! #{percent}% != #{threshold}%")
      abort("Please raise the threshold in jspec/jcov.yml")
    end
  end
end
