# coding: UTF-8

source 'https://rubygems.org'

gemspec

platform :ruby do
  gem 'therubyracer'
end

platform :jruby do
  gem 'therubyrhino'
end

group :assets do
  gem 'coffee-script'
  gem 'coffee-script-source'
end

group :development, :test do
  gem 'actionpack', '~> 3.2'
  gem 'railties',   '~> 3.2'
  gem 'tzinfo'

  gem 'jasminerice'
  gem 'jquery-rails'

  gem 'guard-jasmine'
  gem 'guard-rspec'

  gem 'rake'
  gem 'pry'

  gem 'rspec'

  unless ENV['TRAVIS']
    gem 'yard'
    gem 'redcarpet'
    gem 'thin'
  end
end
