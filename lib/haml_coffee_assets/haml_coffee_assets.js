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

    var Compiler = require('/compiler.js');

    return {

      /**
       * Compile the HAML Coffee template to JavaScript
       *
       * @param name [String] the name of the template that is registered to the namespace
       * @param source [String] the template source code to be compiled
       * @param namespace [String] the template namespace
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
      compile: function(name, source, namespace, format, uglify,
                        escapeHtml, escapeAttributes,
                        customHtmlEscape, customCleanValue, customPreserve, customFindAndPreserve,
                        preserveTags, selfCloseTags,
                        context) {

        var compiler = new Compiler({
          format: format,
          uglify: uglify,
          escapeHtml: escapeHtml,
          escapeAttributes: escapeAttributes,
          customHtmlEscape: customHtmlEscape,
          customCleanValue: customCleanValue,
          customPreserve: customPreserve,
          customFindAndPreserve: customFindAndPreserve,
          preserveTags: preserveTags,
          selfCloseTags: selfCloseTags
        });

        compiler.parse(source);

        var jst = CoffeeScript.compile(compiler.render(name, namespace));

        if (context !== '') {
          jst = jst.replace('fn.call(context);', 'fn.call(' + context +'(context));');
        }

        return jst;
      }

    }
 })();
