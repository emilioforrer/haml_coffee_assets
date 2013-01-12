# coding: UTF-8

module HamlCoffeeAssets
  module Rails

    # Haml Coffee Assets Rails engine that can be configured
    # per environment and registers the tilt template.
    #
    class Engine < ::Rails::Engine

      config.hamlcoffee = ::HamlCoffeeAssets.config

      # Add shared template path to ActionView's load path
      config.before_configuration do |app|
        app.paths["app/views"] << config.hamlcoffee.shared_template_path
      end

      # Initialize Haml Coffee Assets after Sprockets
      #
      initializer 'sprockets.hamlcoffeeassets', :group => :all, :after => 'sprockets.environment' do |app|
        require 'haml_coffee_assets/action_view/template_handler'

        # Register Tilt template (for ActionView)
        ActiveSupport.on_load(:action_view) do
          ::ActionView::Template.register_template_handler(:hamlc, ::HamlCoffeeAssets::ActionView::TemplateHandler)
        end

        next unless app.assets

        # Register Tilt template (for Sprockets)
        app.assets.register_engine '.hamlc', ::HamlCoffeeAssets::Tilt::TemplateHandler
      end

    end

  end
end
