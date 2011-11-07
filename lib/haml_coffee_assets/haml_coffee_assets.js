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
     * Test if the argument is present
     *
     * @param object [Object] the object to test
     * @return [Boolean] whether the object is present
     */
    function isPresent(object) {
      return toString.call(object) === '[object String]' && object.length !== 0
    }

    return {

      /**
       * Compile the HAML Coffee template to JavaScript
       *
       * @param namespace [String] the template namespace
       * @param name [String] the name of the template that is registered to the namespace
       * @param source [String] the template source code to be compiled
       * @param escape [String] the name of the function to escape the output
       * @param context [String] the name of the function to merge contexts
       */
      compile: function(namespace, name, source, escape, context) {

        var compiler, jst;

        if (!isPresent(namespace)) {
           namespace = 'HAML'
        }

        if (isPresent(escape)) {
          compiler = new Compiler({ escape_html: true, custom_html_escape: escape });
        } else {
          compiler = new Compiler({ escape_html: false });
        }

        compiler.parse(source);

        jst = CoffeeScript.compile(compiler.render(name, namespace));

        if (isPresent(context)) {
          jst = jst.replace('fn.call(context);', 'fn.call(' + context +'(context));');
        }

        return jst;
      }

    }
 })();
