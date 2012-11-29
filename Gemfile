# coding: UTF-8

source "http://rubygems.org"

gemspec

platform :ruby do
  gem 'therubyracer'
end

platform :jruby do
  gem 'therubyrhino'
end

group :assets do
  gem 'coffee-script'
end

group :development, :test do
  gem 'actionpack', '~> 3.2'
  gem 'railties',   '~> 3.2'
  gem 'tzinfo'

  gem 'thin'
  gem 'jasminerice'
  gem 'jquery-rails'

  gem 'guard-jasmine'
  gem 'guard-rspec'

  gem 'rake'
  gem 'pry'

  gem 'rspec'

  gem 'rb-fsevent'
  gem 'ruby_gntp'

  unless ENV['TRAVIS']
    gem 'yard'
    gem 'redcarpet'
  end
end
