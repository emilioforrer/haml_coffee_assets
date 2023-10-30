require 'rails'
require 'rspec'
require 'simplecov'
SimpleCov.minimum_coverage 86 if RUBY_VERSION > '3.0' && RUBY_ENGINE == 'ruby'
SimpleCov.start 'rails'
puts [Rails.version, RUBY_VERSION, RUBY_ENGINE, RUBY_DESCRIPTION].inspect

require 'haml_coffee_assets'

RSpec.configure do |config|
  config.color = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.raise_errors_for_deprecations!
end
