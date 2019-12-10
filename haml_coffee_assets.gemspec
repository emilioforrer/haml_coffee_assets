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

  s.required_ruby_version = '>= 1.9.3'
  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'haml_coffee_assets'

  s.files = Dir.glob('{app,lib,vendor}/**/*') + %w[LICENSE README.md]

  s.add_runtime_dependency 'coffee-script', '>= 2'
  s.add_runtime_dependency 'sprockets', '>= 2'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'jquery-rails'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'jasmine'
  s.add_development_dependency 'jasmine-rails'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-jasmine'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rb-readline'
end
