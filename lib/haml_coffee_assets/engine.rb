# coding: UTF-8

module HamlCoffeeAssets

  # Hook the Haml CoffeeScript template into a Rails app.
  #
  class Engine < Rails::Engine

    config.hamlcoffee = ActiveSupport::OrderedOptions.new

    DEFAULT_CONFIG = {
        :format                => 'html5',
        :namespace             => 'window.JST',
        :uglify                => false,
        :escapeHtml            => true,
        :escapeAttributes      => true,
        :customHtmlEscape      => 'HAML.escape',
        :customCleanValue      => 'HAML.cleanValue',
        :customPreserve        => 'HAML.escape',
        :customFindAndPreserve => 'HAML.findAndPreserve',
        :preserve              => 'textarea,pre',
        :autoclose             => 'meta,img,link,br,hr,input,area,param,col,base',
        :context               => 'HAML.context'
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
        config.namespace             = options[:namespace]
        config.format                = options[:format]
        config.uglify                = options[:uglify]
        config.escapeHtml            = options[:escapeHtml]
        config.escapeAttributes      = options[:escapeAttributes]
        config.customHtmlEscape      = options[:customHtmlEscape]
        config.customCleanValue      = options[:customCleanValue]
        config.customPreserve        = options[:customPreserve]
        config.customFindAndPreserve = options[:customFindAndPreserve]
        config.preserveTags          = options[:preserve]
        config.selfCloseTags         = options[:autoclose]
        config.context               = options[:context]
      end
    end

  end
end
