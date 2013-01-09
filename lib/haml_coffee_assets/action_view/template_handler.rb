module HamlCoffeeAssets
  module ActionView
    module TemplateHandler
      def self.call(template)
        <<-RUBY
          jst = ::HamlCoffeeAssets::Compiler.compile("", #{template.source.inspect}, false)
          context = ExecJS.compile("var window = {}, jst = \#{jst} #{hamlcoffee_source}")
          context.eval("jst(\#{local_assigns.to_json})").html_safe
        RUBY
      end

      private

      def self.hamlcoffee_source
        <<-JS
          window.HAML = {
            escape: function (text) { return text; },
            cleanValue: function (text) { return text; },
            context: function (locals) { return locals; },
            preserve: function (text) { return text; },
            findAndPreserve: function (text) { return text; },
            surround: function () {},
            succeed: function () {},
            proceed: function () {}
          };
        JS
      end
    end
  end
end
