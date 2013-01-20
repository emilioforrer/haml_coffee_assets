# coding: UTF-8

require 'haml_coffee_assets/action_view/resolver'

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
        require 'haml_coffee_assets/action_view/template_handler'

        # Register Tilt template (for ActionView)
        ActiveSupport.on_load(:action_view) do
          ::ActionView::Template.register_template_handler(:hamlc, ::HamlCoffeeAssets::ActionView::TemplateHandler)
        end

        # Add template path to ActionController's view paths.
        ActiveSupport.on_load(:action_controller) do
          path = ::HamlCoffeeAssets.config.shared_template_path
          resolver = ::HamlCoffeeAssets::ActionView::Resolver.new(path)
          ::ActionController::Base.append_view_path(resolver)
        end

        next unless app.assets

        # Register Tilt template (for Sprockets)
        app.assets.register_engine '.hamlc', ::HamlCoffeeAssets::Tilt::TemplateHandler
      end

    end

  end
end
