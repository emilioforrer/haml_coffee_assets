# coding: UTF-8

require 'pathname'

require 'tilt'
require 'sprockets'
require 'execjs'

require 'haml_coffee_assets/version'
require 'haml_coffee_assets/configuration'
require 'haml_coffee_assets/compiler'

require 'haml_coffee_assets/tilt/template_handler'

if defined?(Rails)
  require 'rails'
  require 'haml_coffee_assets/rails/engine'
else
  require 'sprockets/engines'
  Sprockets.register_engine '.hamlc', ::HamlCoffeeAssets::Tilt::TemplateHandler
end

# Main Haml Coffee Assets module with
# its configuration settings.
#
module HamlCoffeeAssets

  # Get the Haml Coffee Assets configuration
  #
  # @return [HamlCoffeeAssets::Configuration] the configuration object
  #
  def self.config
    @config ||= ::HamlCoffeeAssets::Configuration.new
  end

end
