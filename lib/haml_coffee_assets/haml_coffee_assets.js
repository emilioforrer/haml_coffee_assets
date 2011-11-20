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
       * @param namespace [String] the template namespace
       * @param name [String] the name of the template that is registered to the namespace
       * @param source [String] the template source code to be compiled
       * @param escapeHtml [Boolean] whether to escape HTML output by default or not
       * @param escapeAttributes [Boolean] whether to escape HTML attributes output by default or not
       * @param customHtmlEscape [String] the name of the function to escape the output
       * @param context [String] the name of the function to merge contexts
       */
      compile: function(name, source, namespace, format, escapeHtml, escapeAttributes, customHtmlEscape, context) {

        var compiler = new Compiler({
          format: format,
          escapeHtml: escapeHtml,
          escapeAttributes: escapeAttributes,
          customHtmlEscape: customHtmlEscape
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
