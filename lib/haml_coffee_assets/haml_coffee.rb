# coding: UTF-8

module HamlCoffeeAssets

  # Handles compilation of Haml CoffeeScript templates to pure JavaScript.
  #
  module HamlCoffee
    
    class Configuration
      
      # Constructor with defaults
      def initialize
        self.namespace              = 'window.JST'
        self.format                 = 'html5'
        self.uglify                 = false
        self.basename               = false
        self.escapeHtml             = true
        self.escapeAttributes       = true
        self.cleanValue             = true
        self.customHtmlEscape       = 'window.HAML.escape'
        self.customCleanValue       = 'window.HAML.cleanValue'
        self.customPreserve         = 'window.HAML.preserve'
        self.customFindAndPreserve  = 'window.HAML.findAndPreserve'
        self.preserveTags           = 'textarea,pre'
        self.selfCloseTags          = 'meta,img,link,br,hr,input,area,param,col,base'
        self.context                = ''
      end
    
      # Template namespace
      #
      attr_accessor :namespace

      # Template format, either html5, html4 or xhtml
      #
      attr_accessor :format

      # Uglify HTML output by skip indention
      #
      attr_accessor :uglify

      # Ignore path when generate the JST
      #
      attr_accessor :basename

      # Escape template code output
      #
      attr_accessor :escapeHtml

      # Escape template code output for attributes
      #
      attr_accessor :escapeAttributes

      # Clean inline CoffeeScript values
      #
      attr_accessor :cleanValue

      # Custom global HTML escaping function
      #
      attr_accessor :customHtmlEscape

      # Custom global code clean value function
      #
      attr_accessor :customCleanValue

      # Custom preserve function
      #
      attr_accessor :customPreserve

      # Custom find and preserve function
      #
      attr_accessor :customFindAndPreserve

      # List of tags to preserve
      #
      attr_accessor :preserveTags

      # List of self closing tags
      #
      attr_accessor :selfCloseTags

      # Custom global context to merge
      #
      attr_accessor :context
    
    end

    class << self
      
      attr_accessor :configuration

      # Configure HamlCoffee
      #
      def configure
        self.configuration ||= Configuration.new
        yield self.configuration
      end

      # Compile the Haml CoffeeScript template.
      #
      # @param [String] name the template name
      # @param [String] source the template source code
      # @param [Boolean] jst if a JST template should be generated
      # @return [String] the compiled template in JavaScript
      #
      def compile(name, source, jst = true)
        self.configuration ||= Configuration.new
        runtime.call('HamlCoffeeAssets.compile', name, source, jst, configuration.namespace, configuration.format, configuration.uglify, configuration.basename,
                     configuration.escapeHtml, configuration.escapeAttributes, configuration.cleanValue,
                     configuration.customHtmlEscape, configuration.customCleanValue,
                     configuration.customPreserve, configuration.customFindAndPreserve,
                     configuration.preserveTags, configuration.selfCloseTags,
                     configuration.context)
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
