/**
 * Fix for the Ruby Rhino
 */
if (!String.prototype.trim) {
    String.prototype.trim = function () {
        return this.replace(/^\s*/, "").replace(/\s*$/, "");
    }
}

/**
 * Haml Coffee Asset compiler.
 */
var HamlCoffeeAssets = (function(){

    var Compiler = require('/haml-coffee.js');

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
       * @param customHtmlEscape [String] the name of the function to escape the output
       * @param customCleanValue [String] the name of the function to clean the code output
       * @param customSurround [String] the name of the function for the surround helper
       * @param customSucceed [String] the name of the function for the succeed helper
       * @param customPrecede [String] the name of the function for the precede helper
       * @param preserveTags [String] comma separated list of tags to preserve whitespace
       * @param selfCloseTags [String] comma separated list of tags to self-closing tags
       * @param context [String] the name of the function to merge contexts
       */
      compile: function(name, source, jst, namespace, format, uglify, basename,
                        escapeHtml, escapeAttributes, cleanValue,
                        customHtmlEscape, customCleanValue, customPreserve, customFindAndPreserve,
                        customSurround, customSucceed, customPrecede,
                        preserveTags, selfCloseTags,
                        context) {

        var compiler = new Compiler({
          format: format,
          uglify: uglify,
          basename: basename,
          escapeHtml: escapeHtml,
          escapeAttributes: escapeAttributes,
          cleanValue: cleanValue,
          customHtmlEscape: customHtmlEscape,
          customCleanValue: customCleanValue,
          customPreserve: customPreserve,
          customFindAndPreserve: customFindAndPreserve,
          customSurround: customSurround,
          customSucceed: customSucceed,
          customPrecede: customPrecede,
          preserveTags: preserveTags,
          selfCloseTags: selfCloseTags
        });

        compiler.parse(source);

        var template;

        if (jst) {
          template = CoffeeScript.compile(compiler.render(name, namespace));
        } else {
          var hamlc = CoffeeScript.compile(compiler.precompile(), { bare: true });
          template = '(function(context) {\n  return (function() {\n' + hamlc.replace(/^(.*)$/mg, '    $1') + '\n  }).call(context);\n});';
        }

        if (context !== '') {
          template = template.replace('.call(context);', '.call(' + context + '(context));');
        }

        return template;
      }

    }
 })();
