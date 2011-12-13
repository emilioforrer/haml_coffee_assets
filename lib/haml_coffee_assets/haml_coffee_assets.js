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
       * @param escapeHtml [Boolean] whether to escape HTML output by default or not
       * @param escapeAttributes [Boolean] whether to escape HTML attributes output by default or not
       * @param customHtmlEscape [String] the name of the function to escape the output
       * @param customCleanValue [String] the name of the function to clean the code output
       * @param preserveTags [String] comma separated list of tags to preserve whitespace
       * @param selfCloseTags [String] comma separated list of tags to self-closing tags
       * @param context [String] the name of the function to merge contexts
       */
      compile: function(name, source, jst, namespace, format, uglify,
                        escapeHtml, escapeAttributes, cleanValue,
                        customHtmlEscape, customCleanValue, customPreserve, customFindAndPreserve,
                        preserveTags, selfCloseTags,
                        context) {

        var compiler = new Compiler({
          format: format,
          uglify: uglify,
          escapeHtml: escapeHtml,
          escapeAttributes: escapeAttributes,
          cleanValue: cleanValue,
          customHtmlEscape: customHtmlEscape,
          customCleanValue: customCleanValue,
          customPreserve: customPreserve,
          customFindAndPreserve: customFindAndPreserve,
          preserveTags: preserveTags,
          selfCloseTags: selfCloseTags
        });

        compiler.parse(source);

        var template;

        if (jst) {
          template = CoffeeScript.compile(compiler.render(name, namespace));
        } else {
          template = CoffeeScript.compile('(context) -> ( ->\n' + compiler.precompile().replace(/^(.*)$/mg, '  $1') + ').call(context)', { bare: true });
        }

        if (context !== '') {
          template = template.replace('.call(context);', '.call(' + context +'(context));');
        }

        return template;
      }

    }
 })();
