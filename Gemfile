# coding: UTF-8

source :rubygems

gemspec

platform :ruby do
  gem 'libv8'
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
