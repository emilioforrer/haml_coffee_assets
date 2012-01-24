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
        :basename              => false,
        :escapeHtml            => true,
        :escapeAttributes      => true,
        :cleanValue            => true,
        :customHtmlEscape      => 'HAML.escape',
        :customCleanValue      => 'HAML.cleanValue',
        :customPreserve        => 'HAML.escape',
        :customFindAndPreserve => 'HAML.findAndPreserve',
        :customSurround        => 'HAML.surround',
        :customSucceed         => 'HAML.succeed',
        :customPrecede         => 'HAML.precede',
        :preserve              => 'textarea,pre',
        :autoclose             => 'meta,img,link,br,hr,input,area,param,col,base',
        :context               => 'HAML.context'
    }

    # Initialize Haml Coffee Assets after Sprockets
    #
    initializer 'sprockets.hamlcoffeeassets', :group => :all, :after => 'sprockets.environment' do |app|
      next unless app.assets

      # Register tilt template
      app.assets.register_engine '.hamlc', HamlCoffeeTemplate

      # Set application configuration for the HAML templates.
      options = DEFAULT_CONFIG.merge(app.config.hamlcoffee)

      HamlCoffee.configure do |config|
        config.namespace             = options[:namespace]
        config.format                = options[:format]
        config.uglify                = options[:uglify]
        config.basename              = options[:basename]
        config.escapeHtml            = options[:escapeHtml]
        config.escapeAttributes      = options[:escapeAttributes]
        config.cleanValue            = options[:cleanValue]
        config.customHtmlEscape      = options[:customHtmlEscape]
        config.customCleanValue      = options[:customCleanValue]
        config.customPreserve        = options[:customPreserve]
        config.customFindAndPreserve = options[:customFindAndPreserve]
        config.customPreserve        = options[:customSurround]
        config.customSucceed         = options[:customSucceed]
        config.customPrecede         = options[:customPrecede]
        config.preserveTags          = options[:preserve]
        config.selfCloseTags         = options[:autoclose]
        config.context               = options[:context]
      end
    end

  end
end
