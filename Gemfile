source 'https://rubygems.org'

gemspec

gem "rack", "~> 2" # Rack 3 is not compatible with Jasmine and fails -- jasmine-3.99.0/lib/jasmine/server.rb:12:in `start': uninitialized constant Rack::Server (NameError)
gem "rails", "~> #{ENV['RAILS_VER'] || raise("missing rails version")}"
gem "sprockets", "~> #{ENV['SPROCKETS_VER'] || raise("missing sprockets version")}"

