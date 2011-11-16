# coding: UTF-8
require File.expand_path('../lib/haml_coffee_assets/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'haml_coffee_assets'
  s.version     = HamlCoffeeAssets::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Michael Kessler']
  s.email       = ['michi@netzpiraten.ch']
  s.homepage    = 'https://github.com/netzpirat/haml_coffee_assets'
  s.summary     = 'Haml CoffeeScript templates'
  s.description = 'Compile Haml CoffeeScript templates in the Rails asset pipeline.'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'haml_coffee_assets'

  s.files         = Dir.glob('{app,lib,vendor}/**/*') + %w[LICENSE README.md]

  s.add_runtime_dependency 'rails',  '>= 3.1'
  s.add_runtime_dependency 'execjs', '~> 1.2.9'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec',       '~> 2.7.0'
  s.add_development_dependency 'guard-rspec', '~> 0.5.0'
  s.add_development_dependency 'yard',        '~> 0.7.3'
  s.add_development_dependency 'redcarpet',   '~> 1.17.2'
  s.add_development_dependency 'pry',         '~> 0.9.6.2'
  s.add_development_dependency 'rake',        '~> 0.9.2.2'
end
