# coding: UTF-8

require 'pathname'

require 'tilt'
require 'sprockets'
require 'execjs'

require 'haml_coffee_assets/version'
require 'haml_coffee_assets/haml_coffee'
require 'haml_coffee_assets/haml_coffee_template'

if defined?(Rails)
  require 'rails'  
  require 'haml_coffee_assets/engine'
else
  require 'sprockets'
  require 'sprockets/engines'
  Sprockets.register_engine '.hamlc', HamlCoffeeAssets::HamlCoffeeTemplate
end
