# coding: UTF-8

module HamlCoffeeAssets
  # Haml Coffee Sprockets processor
  #
  class Transformer
    def initialize(filename, &block)
      @filename = filename
      @source = block.call
    end

    def render(context, empty_hash_wtf)
      self.class.run(@filename, @source, context)
    end

    def self.run(filename, source, context)
      jst  = !!(filename =~ /\.jst\.hamlc(?:\.|$)/)
      name = filename
      name = HamlCoffeeAssets.config.name_filter.call(name) if HamlCoffeeAssets.config.name_filter && !jst

      HamlCoffeeAssets::Compiler.compile(name, source, !jst)
    end

    def self.call(input)
      filename = input[:name]
      source   = input[:data]
      context  = input[:environment].context_class.new(input)

      result = run(filename, source, context)
      context.metadata.merge(data: result)
    end
  end
end
