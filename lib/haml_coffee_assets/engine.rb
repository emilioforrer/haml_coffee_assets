# coding: UTF-8

module HamlCoffeeAssets

  # Hook the Haml CoffeeScript template into a Rails app.
  #
  class Engine < Rails::Engine

    config.hamlcoffee = ActiveSupport::OrderedOptions.new

    DEFAULT_CONFIG = {
        :format           => 'html5',
        :namespace        => 'window.JST',
        :escapeHtml       => true,
        :escapeAttributes => true,
        :customHtmlEscape => 'HAML.escape',
        :context          => 'HAML.context'
    }

    # Initialize Haml Coffee Assets after Sprockets
    #
    initializer 'sprockets.hamlcoffeeassets', :after => 'sprockets.environment' do |app|
      next unless app.assets

      # Register tilt template
      app.assets.register_engine '.hamlc', HamlCoffeeTemplate

      # Set application configuration for the HAML templates.
      options = DEFAULT_CONFIG.merge(app.config.hamlcoffee)

      HamlCoffee.configure do |config|
        config.namespace        = options[:namespace]
        config.format           = options[:format]
        config.escapeHtml       = options[:escapeHtml]
        config.escapeAttributes = options[:escapeAttributes]
        config.customHtmlEscape = options[:customHtmlEscape]
        config.context          = options[:context]
      end
    end

  end
end
