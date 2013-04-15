# coding: UTF-8

require 'coffee-script'

# Haml Coffee Assets main module
#
module HamlCoffeeAssets

  # Handles compilation of Haml Coffee templates to JavaScript.
  #
  module Compiler
    class << self

      # Compile a Haml Coffee template.
      #
      # @param [String] name the template name
      # @param [String] source the template source code
      # @param [Boolean] jst if a JST template should be generated
      # @return [String] the compiled template in JavaScript
      #
      def compile(name, source, jst = true)
        config = HamlCoffeeAssets.config

        runtime.call('HamlCoffeeAssets.compile', name, source, jst,
                     config.namespace, config.format, config.uglify, config.basename,
                     config.escapeHtml, config.escapeAttributes, config.cleanValue, config.placement, config.dependencies,
                     config.customHtmlEscape, config.customCleanValue,
                     config.customPreserve, config.customFindAndPreserve,
                     config.customSurround, config.customSucceed, config.customPrecede, config.customReference,
                     config.preserveTags, config.selfCloseTags,
                     config.context, false)
      end

      private

      # Get the context to compile Haml CoffeeScript templates.
      #
      # @return [Runtime] the JS runtime
      #
      def runtime
        @runtime ||= ExecJS.compile(source)
      end

      # Get the combined source of haml-coffee and CoffeeScript.
      #
      # @return [String] the source code
      #
      def source
        coffeescript + ';' + haml_coffee + ';' + haml_coffee_assets
      end

      # Get the Haml CoffeeScript Assets source code.
      #
      # @return [String] the source
      #
      def haml_coffee_assets
        read_js 'haml_coffee_assets.js'
      end

      # Get the Haml CoffeeScript source code.
      #
      # @return [String] the source
      #
      def haml_coffee
        read_js 'hamlcoffee.js'
      end

      # Get the CoffeeScript source code.
      #
      # @return [String] the source
      #
      def coffeescript
        File.read CoffeeScript::Source.path
      end

      # Read a JavaScript file from the `js` dir.
      #
      # @param [String] filename the javascript filename
      # @return [String] the source
      #
      def read_js(filename)
        Pathname.new(__FILE__).dirname.join('..', 'js', filename).read
      end

    end
  end
end
