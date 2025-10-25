# coding: UTF-8
require File.expand_path('../lib/haml_coffee_assets/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'haml_coffee_assets'
  s.version     = HamlCoffeeAssets::VERSION
  s.authors     = ['Michael Kessler', 'Emilio Forrer', 'Christopher Ostrowski']
  s.email       = ['michi@flinkfinger.com', 'emilio.forrer@gmail.com', 'chris.ostrowski@gmail.com']
  s.homepage    = 'https://github.com/emilioforrer/haml_coffee_assets'
  s.summary     = 'Haml CoffeeScript templates'
  s.description = 'Compile Haml CoffeeScript templates in the Rails asset pipeline.'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.5.8'
  s.required_rubygems_version = '>= 2.5.2'

  s.files = Dir.glob('{app,lib,vendor}/**/*') + %w[LICENSE README.md]

  s.add_runtime_dependency 'coffee-script', '>= 2'
  s.add_runtime_dependency 'railties', '>= 5.2', "< 8.2"
  s.add_runtime_dependency 'sprockets', '>= 3.7'

  s.add_development_dependency 'jasmine'
  s.add_development_dependency 'jasmine-rails'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
end
