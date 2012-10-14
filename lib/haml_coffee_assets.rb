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

  # Get the path to the `hamlcoffee.js.coffee.erb` helper file.
  #
  # @return [String] the absolute path to the helpers file
  #
  def self.helpers_path
    File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'assets', 'javascripts', 'hamlcoffee.js.coffee.erb'))
  end

  # Get the Haml Coffee Assets helper file
  #
  # @param [Boolean] whether to compile the CS helpers or not
  # @return [String] the helpers content
  #
  def self.helpers(compile=true)
    require 'erb'

    content = File.read(HamlCoffeeAssets.helpers_path)
    script = ERB.new(content).result(binding)

    if compile
      require 'coffee-script'
      script = CoffeeScript.compile(script)
    end

    script
  end

end
