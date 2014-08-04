require 'rails'
require 'rspec'
require 'haml_coffee_assets'

RSpec.configure do |config|
  config.color = true
  config.filter_run focus: true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
end
