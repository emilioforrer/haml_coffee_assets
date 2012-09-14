# coding: UTF-8

module HamlCoffeeAssets
  module Rails

    # Haml Coffee Assets Rails engine that can be configured
    # per environment and registers the tilt template.
    #
    class Engine < ::Rails::Engine

      config.hamlcoffee = ::HamlCoffeeAssets.config

      # Initialize Haml Coffee Assets after Sprockets
      #
      initializer 'sprockets.hamlcoffeeassets', :group => :all, :after => 'sprockets.environment' do |app|
        next unless app.assets

        # Register tilt template
        app.assets.register_engine '.hamlc', ::HamlCoffeeAssets::Tilt::TemplateHandler
      end

    end

  end
end
