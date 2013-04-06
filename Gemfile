# coding: UTF-8

source 'https://rubygems.org'

gemspec

platform :ruby do
  gem 'therubyracer', '0.10.2'
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
    gem 'rb-fsevent'
    gem 'ruby_gntp'
    gem 'thin'
  end
end
