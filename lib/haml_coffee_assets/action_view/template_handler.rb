module HamlCoffeeAssets
  module ActionView
    class TemplateHandler
      DEPENDENCY_PATTERN = /(?:window\.)?JST(?:\[["']([\w\/]+)["']\]|\.(\w+))/

      def self.call(template)
        new(template).render
      end

      def self.stale?(last_compile_time)
        GlobalContext.mtime > last_compile_time
      end

      def initialize(template, partial = false, dependencies = [])
        @template     = template
        @partial      = partial
        @dependencies = dependencies
      end

      def render
        "ExecJS.compile(#{ compilation_string }).eval(#{ evaluation_string }).html_safe"
      end

      protected

      def compilation_string
        string = ''

        unless @partial
          string << preamble
          string << helpers
        end

        string << compiled_template

        if @partial
          string
        else
          string.inspect
        end
      end

      private

      def evaluation_string
        string = "JST['#{ logical_path }'](\#{local_assigns.to_json})"
        string.inspect.sub(/\\#/, '#')
      end

      def preamble
        "var window = { JST: {} }, JST = window.JST;\n"
      end

      def helpers
        GlobalContext.to_s
      end

      def compiled_template
        compiled = ::HamlCoffeeAssets::Compiler.compile(
          logical_path,
          @template.source
        )

        include_dependencies(compiled)
      end

      def include_dependencies(compiled)
        compiled.dup.scan(DEPENDENCY_PATTERN) do |match|
          match.compact!

          path = match[0]

          if path == logical_path || @dependencies.include?(path)
            next
          else
            @dependencies << path
          end

          partial = ::ActionView::Template.new(
            partial_source(path),
            path,
            self.class,
            virtual_path: partial_path(path)
          )

          compiled << self.class.new(
            partial,
            true,
            @dependencies
          ).compilation_string
        end

        compiled
      end

      def logical_path
        return @logical_path if defined?(@logical_path)

        path = @template.virtual_path.split('/')
        path.last.sub!(/^_/, '')
        @logical_path = path.join('/')
      end

      def partial_source(path)
        ::Rails.root.join(
          ::HamlCoffeeAssets.config.templates_path,
          partial_path(path) + '.hamlc'
        ).read
      end

      def partial_path(path)
        parts     = path.split('/')
        parts[-1] = "_#{ parts[-1] }"
        parts.join('/')
      end
    end
  end
end
