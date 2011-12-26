# -*- encoding: utf-8 -*-

require File.expand_path('../lib/iso8601-js/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'iso8601-js'
  gem.version       = ISO8601JS::VERSION
  gem.authors       = ['Gopal Patel', 'David Yung', 'Sai Tun']
  gem.email         = ['nixme@stillhope.com', 'azethoth@do.com', 'sai@do.com']
  gem.license       = 'MIT'
  gem.homepage      = 'https://github.com/Do/iso8601.js'
  gem.summary       = 'Sprockets asset gem for the iso8601.js polyfill library'
  gem.description   = 'Adds ISO 8601 support to the JavaScript Date object for all browsers. This is a Sprockets gem to simplify including the client-side library.'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ['lib']

  # Dependencies
  gem.add_dependency 'sprockets', '~> 2.0'
  gem.add_dependency 'coffee-script', '~> 2.2'
  gem.add_development_dependency 'rake'
end
