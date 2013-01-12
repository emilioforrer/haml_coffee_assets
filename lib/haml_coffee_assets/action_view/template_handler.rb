module HamlCoffeeAssets
  module ActionView
    class TemplateHandler
      def self.call(template)
        new(template).render
      end

      def initialize(template)
        @template = template
      end

      def render
        "ExecJS.compile(#{compilation_string}).eval(#{evaluation_string}).html_safe"
      end

      private

      def compilation_string
        (preamble + helpers + compiled_template).inspect
      end

      def evaluation_string
        string = "window.JST['#{@template.virtual_path}'](\#{local_assigns.to_json})"
        string.inspect.sub(/\\#/, "#")
      end

      def preamble
        "var window = {};\n"
      end

      def helpers
        ::HamlCoffeeAssets.helpers
      end

      def compiled_template
        ::HamlCoffeeAssets::Compiler.compile(
          @template.virtual_path,
          @template.source
        )
      end
    end
  end
end
