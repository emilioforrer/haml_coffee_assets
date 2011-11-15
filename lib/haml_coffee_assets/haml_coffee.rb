# coding: UTF-8

module HamlCoffeeAssets

  # Handles compilation of Haml CoffeeScript templates to pure JavaScript.
  #
  module HamlCoffee
    class << self

      mattr_accessor :namespace, :format, :escapeHtml, :escapeAttributes, :customHtmlEscape, :context

      # Configure HamlCoffee
      #
      def configure
        yield self
      end

      # Compile the Haml CoffeeScript template.
      #
      # @param [String] name the template name
      # @param [String] source the template source code
      # @return [String] the compiled template in JavaScript
      #
      def compile(name, source)
        runtime.call('HamlCoffeeAssets.compile',
                     namespace, name, source, format,
                     escapeHtml, escapeAttributes, customHtmlEscape, context)
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
        Pathname.new(__FILE__).dirname.join('haml_coffee_assets.js').read
      end

      # Get the Haml CoffeeScript source code.
      #
      # @return [String] the source
      #
      def haml_coffee
        Pathname.new(__FILE__).dirname.join('..', 'js', 'haml-coffee.js').read
      end

      # Get the CoffeeScript source code.
      #
      # @return [String] the source
      #
      def coffeescript
        Pathname.new(__FILE__).dirname.join('..', 'js', 'coffee-script.js').read
      end

    end
  end
end
