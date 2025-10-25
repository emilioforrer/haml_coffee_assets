source 'https://rubygems.org'

gemspec

gem "rack", "~> 2" # Rack 3 is not compatible with Jasmine and fails -- jasmine-3.99.0/lib/jasmine/server.rb:12:in `start': uninitialized constant Rack::Server (NameError)
gem "rails", "~> #{ENV['RAILS_VER'] || raise("missing rails version")}.0"
gem "sprockets", "~> #{ENV['SPROCKETS_VER'] || raise("missing sprockets version")}"
if ENV['RAILS_VER'].to_f < 7.1
  # default gems required in Ruby 3.4 but not explicitly depended upon
  gem "bigdecimal"
  gem "mutex_m"
  # as https://github.com/rails/rails/pull/49372 was never backported
  gem "concurrent-ruby", "< 1.3.5"
end
