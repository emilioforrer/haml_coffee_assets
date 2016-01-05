# coding: UTF-8

require 'haml_coffee_assets/action_view/resolver'

module HamlCoffeeAssets
  module Rails

    # Haml Coffee Assets Rails engine that can be configured
    # per environment and registers the tilt template.
    #
    class Engine < ::Rails::Engine

      config.hamlcoffee = ::HamlCoffeeAssets.config

      # https://github.com/tricknotes/ember-rails/blob/c45c5d23755ef9f8ab51d9f611cdd3517a11badf/lib/ember_rails.rb#L30
      def configure_assets(app)
        if config.respond_to?(:assets) && config.assets.respond_to?(:configure)
          # Rails 4.x
          config.assets.configure do |env|
            yield env
          end
        else
          # Rails 3.2
          yield app.assets
        end
      end

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

        if ::Rails.env == "development"
          # Monkey patch rails so it busts the server cache for templates
          # depending on the global_context_asset.
          #
          # Currently, the only way to force rails to recompile a server template is to
          # touch it. This is problematic because when the global_context_asset
          # changes we need to manually touch every template that uses the congtext
          # in some way.
          #
          # To ease development, make rails 'touch' and recompile hamlc templates
          # when the global context has changed.
          #
          # Do this ONLY in development.
          #
          # TODO: Don't monkey patch rails.
          module ::ActionView
            class Template
              def stale?
                return false unless ::Rails.env == "development"
                return false unless handler.respond_to?(:stale?)
                handler.stale?(updated_at)
              end

              alias_method :old_render, :render

              # by default, rails will only compile a template once
              # path render so it recompiles the template if 'stale'
              def render(view, locals, buffer=nil, &block)
                if @compiled and stale?
                  now = Time.now
                  File.utime(now, now, identifier) # touch file
                  ::Rails.logger.info "Busted cache for #{identifier} by touching it"

                  view = refresh(view)
                  @source = view.source
                  @compiled = false
                end
                old_render(view, locals, buffer, &block)
              end

            end
          end
        end

        # Register Tilt template (for Sprockets)
        configure_assets(app) do |env|
          env.register_engine '.hamlc', ::HamlCoffeeAssets::Tilt::TemplateHandler
        end
      end

    end

  end
end
