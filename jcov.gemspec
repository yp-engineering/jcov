# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jcov/version"

Gem::Specification.new do |s|
  s.name        = "jcov"
  s.version     = JCov::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Doug McInnes"]
  s.email       = ["dmcinnes@attinteractive.com"]
  s.homepage    = ""
  s.summary     = %q{Javascript Coverage Tool}
  s.description = %q{Javascript Coverage Tool}

  s.add_dependency "commander",       "~> 4.0"
  s.add_dependency "therubyracer",    "0.9.0"
  s.add_dependency "rkelly-dmcinnes", "1.0.3"

  s.add_development_dependency "cucumber", '~> 1.0'
  s.add_development_dependency 'aruba'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.executables = ['jcov']
end
