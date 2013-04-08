/**
 * Haml Coffee Asset compiler.
 */
var HamlCoffeeAssets = (function(){

    var Compiler = require('./haml-coffee');

    return {

      /**
       * Compile the HAML Coffee template to JavaScript
       *
       * @param name [String] the name of the template that is registered to the namespace
       * @param source [String] the template source code to be compiled
       * @param namespace [String] the template namespace
       * @param jst [Boolean] if a JST template should be generated
       * @param format [String] output HTML format
       * @param uglify [Boolean] skip HTML indention
       * @param basename [Boolean] ignore path when generate JST
       * @param escapeHtml [Boolean] whether to escape HTML output by default or not
       * @param escapeAttributes [Boolean] whether to escape HTML attributes output by default or not
       * @param cleanValue [String] the name of the function to clean the values
       * @param placement [String] where to place the function, either `global` or `amd`
       * @param dependencies [Object] the amd module dependencies
       * @param customHtmlEscape [String] the name of the function to escape the output
       * @param customCleanValue [String] the name of the function to clean the code output
       * @param customSurround [String] the name of the function for the surround helper
       * @param customSucceed [String] the name of the function for the succeed helper
       * @param customPrecede [String] the name of the function for the precede helper
       * @param customReference [String] the name of the function for the object reference helper
       * @param preserveTags [String] comma separated list of tags to preserve whitespace
       * @param selfCloseTags [String] comma separated list of tags to self-closing tags
       * @param context [String] the name of the function to merge contexts
       * @param extendScope [Boolean] extend the scope with the context
       */
      compile: function(name, source, jst, namespace, format, uglify, basename,
                        escapeHtml, escapeAttributes, cleanValue, placement, dependencies,
                        customHtmlEscape, customCleanValue, customPreserve, customFindAndPreserve,
                        customSurround, customSucceed, customPrecede, customReference,
                        preserveTags, selfCloseTags,
                        context, extendScope) {

        var compiler = new Compiler({
          name: name,
          namespace: namespace,
          format: format,
          uglify: uglify,
          basename: basename,
          escapeHtml: escapeHtml,
          escapeAttributes: escapeAttributes,
          cleanValue: cleanValue,
          placement: placement,
          dependencies: dependencies,
          customHtmlEscape: customHtmlEscape,
          customCleanValue: customCleanValue,
          customPreserve: customPreserve,
          customFindAndPreserve: customFindAndPreserve,
          customSurround: customSurround,
          customSucceed: customSucceed,
          customPrecede: customPrecede,
          customReference: customReference,
          preserveTags: preserveTags,
          selfCloseTags: selfCloseTags,
          extendScope: extendScope
        });

        compiler.parse(source);

        var template;

        if (jst) {
          template = CoffeeScript.compile(compiler.render());

        } else {
          var hamlc = CoffeeScript.compile(compiler.precompile(), { bare: true });

          if (extendScope) {
            template = '(function(context) {\n  with(context || {}) {\n    return (function() {\n' + hamlc.replace(/^(.*)\n$/mg, '      $1') + '\n    }).call(context);\n  };\n});\n';
          } else {
            template = '(function(context) {\n  return (function() {\n' + hamlc.replace(/^(.*)\n$/mg, '    $1') + '\n  }).call(context);\n});\n';
          }
        }

        if (context !== '' && context !== false) {
          // With AMD we replace the context function with the one from the hamlcoffee AMD module if not set explicit
          if (placement === 'amd' && context === 'window.HAML.context' && /^hamlcoffee/.test(dependencies['hc'])) {
              context = 'hc.context';
          }
          // Only add the global template context for global placement, or when amd with the hamlcoffe module context
          if (placement === 'global' || (placement === 'amd' && context == 'hc.context')) {
              template = template.replace('.call(context);', '.call(' + context + '(context));');
          }
        }

        return template;
      }

    }
 })();
