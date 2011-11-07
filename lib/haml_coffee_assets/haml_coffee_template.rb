# coding: UTF-8

require 'tilt'

module HamlCoffeeAssets

  # Haml CoffeeScript template implementation for Tilt.
  #
  class HamlCoffeeTemplate < Tilt::Template

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
      @output ||= HamlCoffee.compile(name, data)
    end

  end
end

