# coding: UTF-8

module HamlCoffeeAssets
  module Rails

    # Haml Coffee Assets Rails engine that can be configured
    # per environment and registers the tilt template.
    #
    class Engine < ::Rails::Engine

      config.hamlcoffee = ActiveSupport::OrderedOptions.new

      # Initialize Haml Coffee Assets after Sprockets
      #
      initializer 'sprockets.hamlcoffeeassets', :group => :all, :after => 'sprockets.environment' do |app|
        next unless app.assets

        # Register tilt template
        app.assets.register_engine '.hamlc', ::HamlCoffeeAssets::Tilt::TemplateHandler

        # Copy Rails config to the Haml Coffee Assets config
        app.config.hamlcoffee do |key, value|
          HamlCoffeeAssets.config.instance_variable_set("@#{ key }", value)
        end
      end

    end

  end
end
