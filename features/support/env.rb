lib_dir = File.expand_path('../../../lib', __FILE__)

$:.unshift lib_dir

require 'aruba/cucumber'
require 'jcov'
require 'rack'
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara/session'

Capybara.default_selector = :css

include Capybara::DSL

Capybara.app = Rack::Builder.new do
  map "/" do
    use Rack::Static, :urls => ["/"], :root => 'tmp/aruba/jcov'
    run lambda {|env| [404, {}, '']}
  end
end.to_app

Before do
  @aruba_timeout_seconds = 5
end

# add the lib dir to RUBYLIB so bin/jcov can find what it needs
ENV['RUBYLIB'] = lib_dir
