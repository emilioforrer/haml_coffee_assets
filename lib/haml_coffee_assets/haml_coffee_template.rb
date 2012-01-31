# coding: UTF-8

require 'tilt'

module HamlCoffeeAssets

  # Haml CoffeeScript template implementation for Tilt.
  #
  class HamlCoffeeTemplate < Tilt::Template
    
    class << self
      # An optional proc that is called to modify the template name used as the
      # JST key. The proc is passed the name as an argument and should return
      # the modified name (or unmodified) name.
      attr_accessor :name_filter
    end

    self.name_filter = nil
    self.default_mime_type = 'application/javascript'

    # Test if the compiler is initialized.
    #
    # @return [Boolean] the initialization status
    #
    def self.engine_initialized?
      defined? HamlCoffee
    end

    # Initialize the template engine.
    #
    def initialize_engine
      require_template_library 'haml_coffee'
    end

    # Prepare the template
    #
    def prepare
    end

    # Compile the template.
    #
    def evaluate(scope, locals = { }, &block)
      jst = scope.pathname.to_s =~ /\.jst\.hamlc(?:\.|$)/ ? false : true
      name = scope.logical_path
      name = self.class.name_filter.call(name) if self.class.name_filter
      @output ||= HamlCoffee.compile(name, data, jst)
    end

  end
end

