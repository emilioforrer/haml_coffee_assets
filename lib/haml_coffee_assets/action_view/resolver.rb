require "action_view"
require 'active_support'

module HamlCoffeeAssets
  module ActionView
    extend ActiveSupport::Autoload
    autoload_at "action_view/template/resolver" do
      autoload :FileSystemResolver  
    end
    
    # Custom resolver to prevent Haml Coffee templates from being rendered by
    # Rails for non-HTML formats, since a template name without a MIME type
    # in it would normally be a fallback for all formats.
    #
    class Resolver < ::ActionView::FileSystemResolver
      def find_templates(name, prefix, partial, details)
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
