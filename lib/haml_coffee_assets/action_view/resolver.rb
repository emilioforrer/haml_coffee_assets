require "action_view"
require 'action_view/template/resolver'

module HamlCoffeeAssets
  module ActionView
    # Custom resolver to prevent Haml Coffee templates from being rendered by
    # Rails for non-HTML formats, since a template name without a MIME type
    # in it would normally be a fallback for all formats.
    #
    class Resolver < ::ActionView::FileSystemResolver
      def find_templates(name, prefix, partial, details, outside_app_allowed = false)
        if details[:formats].include?(:html)
          clear_cache if ::Rails.env == "development"
          super
        else
          []
        end
      end
    end
  end
end
