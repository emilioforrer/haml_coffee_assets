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

    /**
     * Test if the string argument is present
     *
     * @param object [String] the string to test
     * @return [Boolean] whether the object is present
     */
    function isStringPresent(object) {
      return toString.call(object) === '[object String]' && object.length !== 0
    }

    /**
     * Test if the boolean argument is present
     *
     * @param object [Boolean] the boolean to test
     * @return [Boolean] whether the object is present
     */
    function isBooleanPresent(object) {
      return toString.call(object) === '[object Boolean]'
    }

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
      compile: function(namespace, name, source, format, escapeHtml, escapeAttributes, customHtmlEscape, context) {

        var compiler, jst;

        if (!isStringPresent(namespace)) {
          namespace = 'window.HAML'
        }

        if (!isStringPresent(format)) {
          format = 'html5'
        }

        if (!isBooleanPresent(escapeHtml)) {
          escapeHtml = true
        }

        if (!isBooleanPresent(escapeAttributes)) {
          escapeAttributes = true
        }

        if (!isStringPresent(customHtmlEscape)) {
          customHtmlEscape = 'window.HAML.escape'
        }

        compiler = new Compiler({
          format: format,
          escapeHtml: escapeHtml,
          escapeAttributes: escapeAttributes,
          customHtmlEscape: customHtmlEscape
        });

        compiler.parse(source);

        jst = CoffeeScript.compile(compiler.render(name, namespace));

        if (isStringPresent(context)) {
          jst = jst.replace('fn.call(context);', 'fn.call(' + context +'(context));');
        }

        return jst;
      }

    }
 })();
