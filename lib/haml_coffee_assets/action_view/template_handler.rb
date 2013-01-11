module HamlCoffeeAssets
  module ActionView
    module TemplateHandler
      def self.call(template)
        <<-RUBY
          jst = ::HamlCoffeeAssets::Compiler.compile("", #{template.source.inspect}, false)
          context = ExecJS.compile(%{var window = {}, jst = \#{jst}} + ::HamlCoffeeAssets.helpers)
          context.eval(%{jst(\#{local_assigns.to_json})}).html_safe
        RUBY
      end
    end
  end
end
