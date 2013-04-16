module HamlCoffeeAssets

  # Get the Haml Coffee Assets configuration
  #
  # @return [HamlCoffeeAssets::Configuration] the configuration object
  #
  def self.config
    @config ||= ::HamlCoffeeAssets::Configuration.new
  end

  # Haml Coffee configuration object that contains the default values.
  # It's a plain Ruby object so a Sinatra app doesn't have to depend
  # on ActiveSupport just because of the Rails engine configuration.
  #
  class Configuration

    # Constructor with defaults
    #
    def initialize
      self.namespace              = 'window.JST'
      self.format                 = 'html5'
      self.uglify                 = false
      self.basename               = false
      self.escapeHtml             = true
      self.escapeAttributes       = true
      self.cleanValue             = true
      self.placement              = 'global'
      self.dependencies           = { hc: 'hamlcoffee_amd' }
      self.customHtmlEscape       = 'window.HAML.escape'
      self.customCleanValue       = 'window.HAML.cleanValue'
      self.customPreserve         = 'window.HAML.preserve'
      self.customFindAndPreserve  = 'window.HAML.findAndPreserve'
      self.customSurround         = 'window.HAML.surround'
      self.customSucceed          = 'window.HAML.succeed'
      self.customPrecede          = 'window.HAML.precede'
      self.customReference        = 'window.HAML.reference'
      self.evaluation_object_string = 'assigns.merge(local_assigns).to_json'
      self.preserveTags           = 'textarea,pre'
      self.selfCloseTags          = 'meta,img,link,br,hr,input,area,param,col,base'
      self.context                = 'window.HAML.context'
      self.templates_path         = 'app/assets/javascripts/templates'
      self.global_context_asset   = 'templates/context'
      self.name_filter            = lambda { |n|
        parts = n.sub(/^templates\//, '').split('/')
        parts.last.sub!(/^_/, '')
        parts.join('/')
      }
    end

    # A ruby string that returns an object to evaluate a template against
    #
    attr_accessor :evaluation_object_string

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

    # Define the function placement, either `global` or `amd`
    #
    attr_accessor :placement

    # Define the global amd module dependencies
    #
    attr_accessor :dependencies

    # Custom global HTML escaping function
    #
    attr_accessor :customHtmlEscape

    # Custom global code clean value function
    #
    attr_accessor :customCleanValue

    # Custom global surround function
    #
    attr_accessor :customSurround

    # Custom global succeed function
    #
    attr_accessor :customSucceed

    # Custom global precede function
    #
    attr_accessor :customPrecede

    # Custom preserve function
    #
    attr_accessor :customPreserve

    # Custom object reference function
    #
    attr_accessor :customReference

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

    # A proc that is called to modify the template name used as the
    # JST key. The proc is passed the name as an argument and should
    # return the modified name (or unmodified) name.
    #
    attr_accessor :name_filter

    # Path to templates shared by Rails and JS.
    #
    attr_accessor :templates_path

    # TODO: Remove this deprecated api
    # @deprecated use {#templates_path} instead
    def shared_template_path
      warn "[DEPRECATION] `shared_template_path` is deprecated. Use `templates_path` instead."
      templates_path
    end

    # @deprecated use {#templates_path=} instead
    def shared_template_path=(value)
      warn "[DEPRECATION] `shared_template_path=` is deprecated. Use `templates_path=` instead."
      templates_path=(value)
    end

    # Path to custom helpers shared by Rails and JS.
    #
    attr_accessor :global_context_asset

  end

end
