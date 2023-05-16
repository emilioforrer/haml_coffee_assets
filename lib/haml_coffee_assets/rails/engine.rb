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
      initializer 'sprockets.hamlcoffeeassets', group: :all, after: 'sprockets.environment' do |app|
        require 'haml_coffee_assets/action_view/template_handler'

        # No server side template support with AMD
        if ::HamlCoffeeAssets.config.placement == 'global'

          # Register Tilt template (for ActionView)
          ActiveSupport.on_load(:action_view) do
            ::ActionView::Template.register_template_handler(:hamlc, ::HamlCoffeeAssets::ActionView::TemplateHandler)
          end

          # Add template path to ActionController's view paths.
          ActiveSupport.on_load(:action_controller) do
            path = ::HamlCoffeeAssets.config.templates_path
            resolver = ::HamlCoffeeAssets::ActionView::Resolver.new(path)
            ::ActionController::Base.append_view_path(resolver)
          end
        end

        config.assets.configure do |env|
          if env.respond_to?(:register_transformer)
            env.register_mime_type 'text/hamlc', extensions: ['.hamlc', '.jst.hamlc']
            env.register_transformer 'text/hamlc', 'application/javascript', ::HamlCoffeeAssets::Transformer
            env.register_transformer 'text/hamlc', 'application/javascript+function', ::HamlCoffeeAssets::Transformer
          end

          if env.respond_to?(:register_engine)
            args = ['.hamlc', ::HamlCoffeeAssets::Transformer]
            args << { mime_type: 'text/hamlc', silence_deprecation: true } if Sprockets::VERSION.start_with?('3')
            env.register_engine(*args)
          end
        end
      end

    end

  end
end
