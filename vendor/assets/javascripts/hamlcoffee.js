/**
 * HAML Coffee namespace
 */
window.HAML || (window.HAML = {});

/**
 * HAML Coffee html escape function
 *
 * @param text [String] the text to escape
 * @return [String] the escaped text
 */
window.HAML.escape || (window.HAML.escape = function(text) {
  return ("" + text)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
});

/**
 * HAML Coffee extend function.
 *
 * This will reuse the extend function from either:
 *
 * - jQuery
 * - Underscore.js
 * - Prototype
 * - MooTools
 * - Zepto.js
 *
 * You can assign a custom extend function if your framework
 * is not supported out of the box.
 */
window.HAML.extend || (window.HAML.extend = function(globals, locals) {
  if (jQuery && jQuery.extend) {
    return jQuery.extend({}, globals, locals);
  }
  else if (_ && _.extend) {
    return _.extend({}, globals, locals);
  }
  else if (Zepto && Zepto.extend) {
    return Zepto.extend(Zepto.extend({}, globals), locals);
  }
  else if (Object.extend) {
    return Object.extend(Object.extend({}, globals), locals)
  }
  else if (Object.append) {
    return Object.append(Object.append({}, globals), locals)
  }
  else { return locals }
});

/**
 * HAML Coffee global template context.
 *
 * @return [Object] the global template context
 */
window.HAML.globals || (window.HAML.globals = function() {
  return {}
});

/**
 * Get the HAML template context. This merges the local
 * and the global template context into a new context.
 *
 * @param locals [Object] the local template context
 * @return [Object] the merged context
 */
window.HAML.context || (window.HAML.context = function(locals) {
  return HAML.extend(HAML.globals(), locals)
});
