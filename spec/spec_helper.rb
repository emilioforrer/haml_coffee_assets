require 'rails'
require 'rspec'
require 'haml_coffee_assets'

RSpec.configure do |config|
  config.color = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.raise_errors_for_deprecations!
end
