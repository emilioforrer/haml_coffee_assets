# coding: UTF-8

require 'tilt'

module HamlCoffeeAssets
  module Tilt

    # Haml Coffee template handler implementation for Tilt.
    #
    class TemplateHandler < ::Tilt::Template

      self.default_mime_type = 'application/javascript'

      # Test if the compiler is initialized.
      #
      # @return [Boolean] the initialization status
      #
      def self.engine_initialized?
        defined? HamlCoffeeAssets::Compiler
      end

      # Initialize the template engine.
      #
      def initialize_engine
        require_template_library 'haml_coffee_assets/compiler'
      end

      # Prepare the template
      #
      def prepare
      end

      # Compile the template.
      #
      def evaluate(scope, locals = { }, &block)
        jst  = !!(scope.pathname.to_s =~ /\.jst\.hamlc(?:\.|$)/)
        name = scope.logical_path
        name = HamlCoffeeAssets.config.name_filter.call(name) if HamlCoffeeAssets.config.name_filter && !jst

        @output ||= HamlCoffeeAssets::Compiler.compile(name, data, !jst)
      end

      private

    end

  end
end
