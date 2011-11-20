# coding: UTF-8

module HamlCoffeeAssets

  # Handles compilation of Haml CoffeeScript templates to pure JavaScript.
  #
  module HamlCoffee

    # Template namespace
    #
    mattr_accessor :namespace
    self.namespace = 'window.JST'

    # Template format, either html5, html4 or xhtml
    #
    mattr_accessor :format
    self.format = 'html5'

    # Escape template code output
    #
    mattr_accessor :escapeHtml
    self.escapeHtml = true

    # Escape template code output for attributes
    #
    mattr_accessor :escapeAttributes
    self.escapeAttributes = true

    # Custom global HTML escaping function
    #
    mattr_accessor :customHtmlEscape
    self.customHtmlEscape = 'window.HAML.escape'

    # Custom global context to merge
    #
    mattr_accessor :context
    self.context = ''

    class << self

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
        runtime.call('HamlCoffeeAssets.compile', name, source,
                     HamlCoffee.namespace, HamlCoffee.format, HamlCoffee.escapeHtml, HamlCoffee.escapeAttributes,
                     HamlCoffee.customHtmlEscape, HamlCoffee.context)
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
