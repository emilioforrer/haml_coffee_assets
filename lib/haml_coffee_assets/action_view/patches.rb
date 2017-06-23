# See patch notes inline
module HamlCoffeeAssets::ActionView
  module Patches
    def self.included(base)
      base.send :include, InstanceMethods
      base.send :alias_method, :handle_render_error_without_patch, :handle_render_error
      base.send :alias_method, :handle_render_error, :handle_render_error_with_patch
    end

    module InstanceMethods
      # Patch, it's almost exaclty the same with a small tweak
      def handle_render_error_with_patch(view, e) #:nodoc:
        if e.is_a?(::ActionView::Template::Error)
          e.sub_template_of(self)
          raise e
        else
          assigns  = view.respond_to?(:assigns) ? view.assigns : {}
          template = self

          # Here's the patch: if the javascript runtime throws an error
          # during compilation, we get to this handler but our view 
          # doesn't have a lookup_context - thus throwing a very hard
          # to debug error in Template#refresh. To circumvent, ensure the
          # view responds to lookup_context before refreshing.
          if view.respond_to?(:lookup_context) and template.source.nil?
            template = refresh(view)
            template.encode! if template.respond_to?(:encode!)
          end

          if ::Rails::VERSION::STRING < "4"
            raise ::ActionView::Template::Error.new(template, assigns, e)
          elsif ::Rails::VERSION::STRING < "5.1"
            raise ::ActionView::Template::Error.new(template, e)
          else
            raise ::ActionView::Template::Error.new(template)
          end
        end
      end
    end

  end
end

::ActionView::Template.send :include, HamlCoffeeAssets::ActionView::Patches if defined? ::ActionView::Template
