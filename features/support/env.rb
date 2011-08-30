lib_dir = File.expand_path('../../../lib', __FILE__)

$:.unshift lib_dir

require 'aruba/cucumber'
require 'jcov'

# add the lib dir to RUBYLIB so bin/jcov can find what it needs
ENV['RUBYLIB'] = lib_dir
