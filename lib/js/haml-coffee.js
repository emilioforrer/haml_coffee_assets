var require = function (file, cwd) {
    var resolved = require.resolve(file, cwd || '/');
    var mod = require.modules[resolved];
    if (!mod) throw new Error(
        'Failed to resolve module ' + file + ', tried ' + resolved
    );
    var res = mod._cached ? mod._cached : mod();
    return res;
}

require.paths = [];
require.modules = {};
require.extensions = [".js",".coffee"];

require._core = {
    'assert': true,
    'events': true,
    'fs': true,
    'path': true,
    'vm': true
};

require.resolve = (function () {
    return function (x, cwd) {
        if (!cwd) cwd = '/';
        
        if (require._core[x]) return x;
        var path = require.modules.path();
        var y = cwd || '.';
        
        if (x.match(/^(?:\.\.?\/|\/)/)) {
            var m = loadAsFileSync(path.resolve(y, x))
                || loadAsDirectorySync(path.resolve(y, x));
            if (m) return m;
        }
        
        var n = loadNodeModulesSync(x, y);
        if (n) return n;
        
        throw new Error("Cannot find module '" + x + "'");
        
        function loadAsFileSync (x) {
            if (require.modules[x]) {
                return x;
            }
            
            for (var i = 0; i < require.extensions.length; i++) {
                var ext = require.extensions[i];
                if (require.modules[x + ext]) return x + ext;
            }
        }
        
        function loadAsDirectorySync (x) {
            x = x.replace(/\/+$/, '');
            var pkgfile = x + '/package.json';
            if (require.modules[pkgfile]) {
                var pkg = require.modules[pkgfile]();
                var b = pkg.browserify;
                if (typeof b === 'object' && b.main) {
                    var m = loadAsFileSync(path.resolve(x, b.main));
                    if (m) return m;
                }
                else if (typeof b === 'string') {
                    var m = loadAsFileSync(path.resolve(x, b));
                    if (m) return m;
                }
                else if (pkg.main) {
                    var m = loadAsFileSync(path.resolve(x, pkg.main));
                    if (m) return m;
                }
            }
            
            return loadAsFileSync(x + '/index');
        }
        
        function loadNodeModulesSync (x, start) {
            var dirs = nodeModulesPathsSync(start);
            for (var i = 0; i < dirs.length; i++) {
                var dir = dirs[i];
                var m = loadAsFileSync(dir + '/' + x);
                if (m) return m;
                var n = loadAsDirectorySync(dir + '/' + x);
                if (n) return n;
            }
            
            var m = loadAsFileSync(x);
            if (m) return m;
        }
        
        function nodeModulesPathsSync (start) {
            var parts;
            if (start === '/') parts = [ '' ];
            else parts = path.normalize(start).split('/');
            
            var dirs = [];
            for (var i = parts.length - 1; i >= 0; i--) {
                if (parts[i] === 'node_modules') continue;
                var dir = parts.slice(0, i + 1).join('/') + '/node_modules';
                dirs.push(dir);
            }
            
            return dirs;
        }
    };
})();

require.alias = function (from, to) {
    var path = require.modules.path();
    var res = null;
    try {
        res = require.resolve(from + '/package.json', '/');
    }
    catch (err) {
        res = require.resolve(from, '/');
    }
    var basedir = path.dirname(res);
    
    var keys = Object_keys(require.modules);
    
    for (var i = 0; i < keys.length; i++) {
        var key = keys[i];
        if (key.slice(0, basedir.length + 1) === basedir + '/') {
            var f = key.slice(basedir.length);
            require.modules[to + f] = require.modules[basedir + f];
        }
        else if (key === basedir) {
            require.modules[to] = require.modules[basedir];
        }
    }
};

require.define = function (filename, fn) {
    var dirname = require._core[filename]
        ? ''
        : require.modules.path().dirname(filename)
    ;
    
    var require_ = function (file) {
        return require(file, dirname)
    };
    require_.resolve = function (name) {
        return require.resolve(name, dirname);
    };
    require_.modules = require.modules;
    require_.define = require.define;
    var module_ = { exports : {} };
    
    require.modules[filename] = function () {
        require.modules[filename]._cached = module_.exports;
        fn.call(
            module_.exports,
            require_,
            module_,
            module_.exports,
            dirname,
            filename
        );
        require.modules[filename]._cached = module_.exports;
        return module_.exports;
    };
};

var Object_keys = Object.keys || function (obj) {
    var res = [];
    for (var key in obj) res.push(key)
    return res;
};

if (typeof process === 'undefined') process = {};

if (!process.nextTick) process.nextTick = function (fn) {
    setTimeout(fn, 0);
};

if (!process.title) process.title = 'browser';

if (!process.binding) process.binding = function (name) {
    if (name === 'evals') return require('vm')
    else throw new Error('No such module')
};

if (!process.cwd) process.cwd = function () { return '.' };

require.define("path", function (require, module, exports, __dirname, __filename) {
    function filter (xs, fn) {
    var res = [];
    for (var i = 0; i < xs.length; i++) {
        if (fn(xs[i], i, xs)) res.push(xs[i]);
    }
    return res;
}

// resolves . and .. elements in a path array with directory names there
// must be no slashes, empty elements, or device names (c:\) in the array
// (so also no leading and trailing slashes - it does not distinguish
// relative and absolute paths)
function normalizeArray(parts, allowAboveRoot) {
  // if the path tries to go above the root, `up` ends up > 0
  var up = 0;
  for (var i = parts.length; i >= 0; i--) {
    var last = parts[i];
    if (last == '.') {
      parts.splice(i, 1);
    } else if (last === '..') {
      parts.splice(i, 1);
      up++;
    } else if (up) {
      parts.splice(i, 1);
      up--;
    }
  }

  // if the path is allowed to go above the root, restore leading ..s
  if (allowAboveRoot) {
    for (; up--; up) {
      parts.unshift('..');
    }
  }

  return parts;
}

// Regex to split a filename into [*, dir, basename, ext]
// posix version
var splitPathRe = /^(.+\/(?!$)|\/)?((?:.+?)?(\.[^.]*)?)$/;

// path.resolve([from ...], to)
// posix version
exports.resolve = function() {
var resolvedPath = '',
    resolvedAbsolute = false;

for (var i = arguments.length; i >= -1 && !resolvedAbsolute; i--) {
  var path = (i >= 0)
      ? arguments[i]
      : process.cwd();

  // Skip empty and invalid entries
  if (typeof path !== 'string' || !path) {
    continue;
  }

  resolvedPath = path + '/' + resolvedPath;
  resolvedAbsolute = path.charAt(0) === '/';
}

// At this point the path should be resolved to a full absolute path, but
// handle relative paths to be safe (might happen when process.cwd() fails)

// Normalize the path
resolvedPath = normalizeArray(filter(resolvedPath.split('/'), function(p) {
    return !!p;
  }), !resolvedAbsolute).join('/');

  return ((resolvedAbsolute ? '/' : '') + resolvedPath) || '.';
};

// path.normalize(path)
// posix version
exports.normalize = function(path) {
var isAbsolute = path.charAt(0) === '/',
    trailingSlash = path.slice(-1) === '/';

// Normalize the path
path = normalizeArray(filter(path.split('/'), function(p) {
    return !!p;
  }), !isAbsolute).join('/');

  if (!path && !isAbsolute) {
    path = '.';
  }
  if (path && trailingSlash) {
    path += '/';
  }
  
  return (isAbsolute ? '/' : '') + path;
};


// posix version
exports.join = function() {
  var paths = Array.prototype.slice.call(arguments, 0);
  return exports.normalize(filter(paths, function(p, index) {
    return p && typeof p === 'string';
  }).join('/'));
};


exports.dirname = function(path) {
  var dir = splitPathRe.exec(path)[1] || '';
  var isWindows = false;
  if (!dir) {
    // No dirname
    return '.';
  } else if (dir.length === 1 ||
      (isWindows && dir.length <= 3 && dir.charAt(1) === ':')) {
    // It is just a slash or a drive letter with a slash
    return dir;
  } else {
    // It is a full dirname, strip trailing slash
    return dir.substring(0, dir.length - 1);
  }
};


exports.basename = function(path, ext) {
  var f = splitPathRe.exec(path)[2] || '';
  // TODO: make this comparison case-insensitive on windows?
  if (ext && f.substr(-1 * ext.length) === ext) {
    f = f.substr(0, f.length - ext.length);
  }
  return f;
};


exports.extname = function(path) {
  return splitPathRe.exec(path)[3] || '';
};

});

require.define("/nodes/node.js", function (require, module, exports, __dirname, __filename) {
    (function() {
  var Node, e, w;

  e = require('../helper').escapeHTML;

  w = require('../helper').whitespace;

  module.exports = Node = (function() {

    Node.CLEAR_WHITESPACE_LEFT = '\u0091';

    Node.CLEAR_WHITESPACE_RIGHT = '\u0092';

    function Node(expression, options) {
      this.expression = expression != null ? expression : '';
      if (options == null) options = {};
      this.parentNode = options.parentNode;
      this.children = [];
      this.opener = this.closer = null;
      this.silent = false;
      this.preserve = false;
      this.wsRemoval = {
        around: false,
        inside: false
      };
      this.escapeHtml = options.escapeHtml;
      this.escapeAttributes = options.escapeAttributes;
      this.format = options.format;
      this.codeBlockLevel = options.codeBlockLevel;
      this.blockLevel = options.blockLevel;
    }

    Node.prototype.addChild = function(child) {
      this.children.push(child);
      return this;
    };

    Node.prototype.getOpener = function() {
      if (this.wsRemoval.around && this.opener.text) {
        this.opener.text = Node.CLEAR_WHITESPACE_LEFT + this.opener.text;
      }
      if (this.wsRemoval.inside && this.opener.text) {
        this.opener.text += Node.CLEAR_WHITESPACE_RIGHT;
      }
      return this.opener;
    };

    Node.prototype.getCloser = function() {
      if (this.wsRemoval.inside && this.closer.text) {
        this.closer.text = Node.CLEAR_WHITESPACE_LEFT + this.closer.text;
      }
      if (this.wsRemoval.around && this.closer.text) {
        this.closer.text += Node.CLEAR_WHITESPACE_RIGHT;
      }
      return this.closer;
    };

    Node.prototype.isPreserved = function() {
      if (this.preserve) return true;
      if (this.parentNode) {
        return this.parentNode.isPreserved();
      } else {
        return false;
      }
    };

    Node.prototype.markText = function(text, escape) {
      if (escape == null) escape = false;
      return {
        type: 'text',
        cw: this.codeBlockLevel,
        hw: this.blockLevel - this.codeBlockLevel + 2,
        text: escape ? e(text) : text
      };
    };

    Node.prototype.markRunningCode = function(code) {
      return {
        type: 'run',
        cw: this.codeBlockLevel,
        code: code
      };
    };

    Node.prototype.markInsertingCode = function(code, escape) {
      if (escape == null) escape = false;
      return {
        type: 'insert',
        cw: this.codeBlockLevel,
        hw: this.blockLevel,
        escape: escape,
        code: code
      };
    };

    Node.prototype.evaluate = function() {};

    Node.prototype.render = function() {
      var child, output, preserve, tag, _i, _j, _k, _l, _len, _len2, _len3, _len4, _ref, _ref2, _ref3, _ref4;
      output = [];
      if (this.silent) return output;
      if (this.children.length === 0) {
        if (this.opener && this.closer) {
          tag = this.getOpener();
          tag.text += this.getCloser().text;
          output.push(tag);
        } else {
          if (!this.preserve && this.isPreserved()) {
            output.push(this.getOpener());
          } else {
            output.push(this.getOpener());
          }
        }
      } else {
        if (this.opener && this.closer) {
          if (this.preserve) {
            preserve = this.getOpener().text;
            _ref = this.children;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              child = _ref[_i];
              preserve += "" + (child.render()[0].text) + "\\n" + (w(this.blockLevel));
            }
            preserve = preserve.replace(/\\n\s*$/, '');
            preserve += this.getCloser().text;
            output.push(this.markText(preserve));
          } else {
            output.push(this.getOpener());
            _ref2 = this.children;
            for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
              child = _ref2[_j];
              output = output.concat(child.render());
            }
            output.push(this.getCloser());
          }
        } else if (this.opener) {
          output.push(this.getOpener());
          _ref3 = this.children;
          for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
            child = _ref3[_k];
            output = output.concat(child.render());
          }
        } else {
          _ref4 = this.children;
          for (_l = 0, _len4 = _ref4.length; _l < _len4; _l++) {
            child = _ref4[_l];
            output.push(this.markText(child.render().text));
          }
        }
      }
      return output;
    };

    return Node;

  })();

}).call(this);

});

require.define("/helper.js", function (require, module, exports, __dirname, __filename) {
    
  module.exports = {
    whitespace: function(n) {
      var a;
      n = n * 2;
      a = [];
      while (a.length < n) {
        a.push(' ');
      }
      return a.join('');
    },
    escapeQuotes: function(text) {
      if (!text) return '';
      return text.replace(/"/g, '\\"');
    },
    escapeHTML: function(text) {
      if (!text) return '';
      return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\"/g, '&quot;');
    }
  };

});

require.define("/nodes/text.js", function (require, module, exports, __dirname, __filename) {
    (function() {
  var Node, Text, eq;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Node = require('./node');

  eq = require('../helper').escapeQuotes;

  module.exports = Text = (function() {

    __extends(Text, Node);

    function Text() {
      Text.__super__.constructor.apply(this, arguments);
    }

    Text.prototype.evaluate = function() {
      return this.opener = this.markText(eq(this.expression));
    };

    return Text;

  })();

}).call(this);

});

require.define("/nodes/haml.js", function (require, module, exports, __dirname, __filename) {
    (function() {
  var Haml, Node, eq;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Node = require('./node');

  eq = require('../helper').escapeQuotes;

  module.exports = Haml = (function() {

    __extends(Haml, Node);

    function Haml() {
      Haml.__super__.constructor.apply(this, arguments);
    }

    Haml.selfCloseTags = ['meta', 'img', 'link', 'br', 'hr', 'input', 'area', 'param', 'col', 'base'];

    Haml.preserveTags = ['pre', 'textarea'];

    Haml.prototype.evaluate = function() {
      var code, prefix, tokens;
      tokens = this.parseExpression(this.expression);
      if (tokens.doctype) {
        return this.opener = this.markText("" + (eq(this.buildDocType(tokens.doctype))));
      } else {
        if (this.isNotSelfClosing(tokens.tag)) {
          prefix = eq(this.buildHtmlTagPrefix(tokens));
          if (tokens.assignment) {
            code = this.escapeHtml ? "\#{e " + tokens.assignment + "}" : "\#{" + tokens.assignment + "}";
            this.opener = this.markText("" + prefix + ">" + code);
            return this.closer = this.markText("</" + tokens.tag + ">");
          } else if (tokens.text) {
            this.opener = this.markText("" + prefix + ">" + tokens.text);
            return this.closer = this.markText("</" + tokens.tag + ">");
          } else {
            this.opener = this.markText(prefix + '>');
            return this.closer = this.markText("</" + tokens.tag + ">");
          }
        } else {
          tokens.tag = tokens.tag.replace(/\/$/, '');
          prefix = eq(this.buildHtmlTagPrefix(tokens));
          return this.opener = this.markText("" + prefix + (this.format === 'xhtml' ? ' /' : '') + ">");
        }
      }
    };

    Haml.prototype.parseExpression = function(exp) {
      var attribute, attributes, classes, id, tag, _i, _len, _ref, _ref2;
      tag = this.parseTag(exp);
      if (Haml.preserveTags.indexOf(tag.tag) !== -1) this.preserve = true;
      id = (_ref = tag.ids) != null ? _ref.pop() : void 0;
      classes = tag.classes;
      attributes = [];
      if (tag.attributes) {
        _ref2 = tag.attributes;
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          attribute = _ref2[_i];
          if (attribute.key === 'id') {
            if (id) {
              id += '_' + attribute.value;
            } else {
              id = attribute.value;
            }
          } else if (attribute.key === 'class') {
            classes || (classes = []);
            classes.push(attribute.value);
          } else {
            attributes.push(attribute);
          }
        }
      }
      return {
        doctype: tag.doctype,
        tag: tag.tag,
        id: id,
        classes: classes,
        text: tag.text,
        attributes: attributes,
        assignment: tag.assignment
      };
    };

    Haml.prototype.parseTag = function(exp) {
      var assignment, attributes, classes, doctype, haml, id, ids, klass, tag, text, tokens, whitespace, _ref, _ref2, _ref3;
      try {
        doctype = (_ref = exp.match(/^(\!{3}.*)/)) != null ? _ref[1] : void 0;
        if (doctype) {
          return {
            doctype: doctype
          };
        }
        tokens = exp.match(/^((?:[#%\.][a-z0-9_:\-]*[\/]?)+)([\(\{].*[\)\}])?([\<\>]{0,2})(.*)?$/i);
        haml = tokens[1];
        attributes = tokens[2];
        whitespace = tokens[3];
        if (tokens[4] && !tokens[4].match(/^=/)) {
          text = tokens[4].replace(/^ /, '');
        } else {
          assignment = (_ref2 = tokens[4]) != null ? (_ref3 = _ref2.match(/\=\s*(\S+.*)$/)) != null ? _ref3[1] : void 0 : void 0;
        }
        if (whitespace) {
          if (whitespace.indexOf('>') !== -1) this.wsRemoval.around = true;
          if (whitespace.indexOf('<') !== -1) {
            this.wsRemoval.inside = true;
            this.preserve = true;
          }
        }
        tag = haml.match(/\%([a-z_\-][a-z0-9_:\-]*[\/]?)/i);
        ids = haml.match(/\#([a-z_\-][a-z0-9_\-]*)/gi);
        classes = haml.match(/\.([a-z0-9_\-]*)/gi);
        return {
          tag: tag ? tag[1] : 'div',
          ids: ids ? (function() {
            var _i, _len, _results;
            _results = [];
            for (_i = 0, _len = ids.length; _i < _len; _i++) {
              id = ids[_i];
              _results.push(id.substr(1));
            }
            return _results;
          })() : void 0,
          classes: classes ? (function() {
            var _i, _len, _results;
            _results = [];
            for (_i = 0, _len = classes.length; _i < _len; _i++) {
              klass = classes[_i];
              _results.push(klass.substr(1));
            }
            return _results;
          })() : void 0,
          attributes: this.parseAttributes(attributes),
          assignment: assignment,
          text: text
        };
      } catch (error) {
        throw "Unable to parse tag from " + exp + ": " + error;
      }
    };

    Haml.prototype.parseAttributes = function(exp) {
      var attributes, findAttributes, key, match, quoted, value;
      attributes = [];
      findAttributes = /(?:(['"]?\w+[\w:-]*['"]?)\s*=\s*("(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|[\w@.]+)|(['"]?\w+[\w:-]*['"]?)\s*=>\s*("(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|[-\w@.()'"]+)|(['"]?\w+[\w:-]*['"]?):\s*("(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|[-\w@.()'"]+))/g;
      while (match = findAttributes.exec(exp)) {
        key = match[1] || match[3] || match[5];
        value = match[2] || match[4] || match[6];
        if (['false', '"false"', "'false'", '', '""', "''"].indexOf(value) === -1) {
          if (['true', '"true"', "'true'"].indexOf(value) !== -1) {
            value = "'" + key + "'";
          } else if (!value.match(/^("|').*\1$/)) {
            if (this.escapeAttributes) {
              value = '\'#{ e(' + value + ') }\'';
            } else {
              value = '\'#{ ' + value + ' }\'';
            }
          }
          if (quoted = value.match(/^("|')(.*)\1$/)) value = quoted[2];
          if (quoted = key.match(/^("|')(.*)\1$/)) key = quoted[2];
          attributes.push({
            key: key,
            value: value
          });
        }
      }
      return attributes;
    };

    Haml.prototype.buildHtmlTagPrefix = function(tokens) {
      var attribute, classes, interpolation, klass, tagParts, _i, _j, _len, _len2, _ref, _ref2;
      tagParts = ["<" + tokens.tag];
      if (tokens.classes) {
        classes = tokens.classes.sort().join(' ');
        if (tokens.classes.length > 1 && classes.match(/#\{/)) {
          classes = '#{ [';
          _ref = tokens.classes;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            klass = _ref[_i];
            if (interpolation = klass.match(/#{(.*)}/)) {
              classes += interpolation[1] + ',';
            } else {
              classes += "'" + klass + "',";
            }
          }
          classes += '].sort().join(\' \') }';
        }
        tagParts.push("class='" + classes + "'");
      }
      if (tokens.id) tagParts.push("id='" + tokens.id + "'");
      if (tokens.attributes) {
        _ref2 = tokens.attributes;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          attribute = _ref2[_j];
          if (attribute.key !== attribute.value || this.format !== 'html5') {
            tagParts.push("" + attribute.key + "=" + (this.quoteAttributeValue(attribute.value)));
          } else {
            tagParts.push("" + attribute.key);
          }
        }
      }
      return tagParts.join(' ');
    };

    Haml.prototype.quoteAttributeValue = function(value) {
      var quoted;
      if (value.indexOf("'") === -1) {
        quoted = "'" + value + "'";
      } else {
        quoted = "\"" + value + "\"";
      }
      return quoted;
    };

    Haml.prototype.buildDocType = function(doctype) {
      switch ("" + this.format + " " + doctype) {
        case 'xhtml !!! XML':
          return '<?xml version=\'1.0\' encoding=\'utf-8\' ?>';
        case 'xhtml !!!':
          return '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
        case 'xhtml !!! 1.1':
          return '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">';
        case 'xhtml !!! mobile':
          return '<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">';
        case 'xhtml !!! basic':
          return '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">';
        case 'xhtml !!! frameset':
          return '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">';
        case 'xhtml !!! 5':
        case 'html5 !!!':
          return '<!DOCTYPE html>';
        case 'html5 !!! XML':
        case 'html4 !!! XML':
          return '';
        case 'html4 !!!':
          return '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">';
        case 'html4 !!! frameset':
          return '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">';
        case 'html4 !!! strict':
          return '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">';
      }
    };

    Haml.prototype.isNotSelfClosing = function(tag) {
      return Haml.selfCloseTags.indexOf(tag) === -1 && !tag.match(/\/$/);
    };

    return Haml;

  })();

}).call(this);

});

require.define("/nodes/code.js", function (require, module, exports, __dirname, __filename) {
    (function() {
  var Code, Node;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Node = require('./node');

  module.exports = Code = (function() {

    __extends(Code, Node);

    function Code() {
      Code.__super__.constructor.apply(this, arguments);
    }

    Code.prototype.evaluate = function() {
      var code, codeBlock, identifier;
      codeBlock = this.expression.match(/(-|!=|\&=|=|~)\s?(.*)?/);
      identifier = codeBlock[1];
      code = codeBlock[2];
      if (identifier === '-') {
        this.opener = this.markRunningCode(code);
        if (this.children.length !== 0 && this.opener.code.match(/(->|=>)/)) {
          return this.closer = this.markRunningCode("  ''");
        }
      } else if (identifier === '~') {
        return this.opener = this.markInsertingCode(this.findAndPreserve(code));
      } else if (identifier === '&=' || (identifier === '=' && this.escapeHtml)) {
        return this.opener = this.markInsertingCode(code, true);
      } else if (identifier === '!=' || (identifier === '=' && !this.escapeHtml)) {
        return this.opener = this.markInsertingCode(code);
      }
    };

    Code.prototype.findAndPreserve = function(code) {
      return code.replace(/<(pre|textarea)>(.*?)<\/\1>/g, function(text) {
        return text.replace('\\n', '\&\#x000A;');
      });
    };

    return Code;

  })();

}).call(this);

});

require.define("/nodes/comment.js", function (require, module, exports, __dirname, __filename) {
    (function() {
  var Comment, Node;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Node = require('./node');

  module.exports = Comment = (function() {

    __extends(Comment, Node);

    function Comment() {
      Comment.__super__.constructor.apply(this, arguments);
    }

    Comment.prototype.evaluate = function() {
      var comment, expression, identifier, _ref;
      _ref = this.expression.match(/(-#|\/\[|\/)\s?(.*)?/), expression = _ref[0], identifier = _ref[1], comment = _ref[2];
      switch (identifier) {
        case '-#':
          this.silent = true;
          return this.opener = this.markText('');
        case '\/[':
          this.opener = this.markText("<!--[" + comment + ">");
          return this.closer = this.markText('<![endif]-->');
        case '\/':
          if (comment) {
            this.opener = this.markText("<!-- " + comment);
            return this.closer = this.markText(' -->');
          } else {
            this.opener = this.markText("<!--");
            return this.closer = this.markText('-->');
          }
      }
    };

    return Comment;

  })();

}).call(this);

});

require.define("/nodes/filter.js", function (require, module, exports, __dirname, __filename) {
    (function() {
  var Filter, Node, w;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Node = require('./node');

  w = require('../helper').whitespace;

  module.exports = Filter = (function() {

    __extends(Filter, Node);

    function Filter() {
      Filter.__super__.constructor.apply(this, arguments);
    }

    Filter.prototype.evaluate = function() {
      var _ref;
      return this.filter = (_ref = this.expression.match(/:(escaped|preserve|css|javascript|coffeescript|plain|cdata|coffeescript)(.*)?/)) != null ? _ref[1] : void 0;
    };

    Filter.prototype.render = function() {
      var child, indent, output, preserve, _i, _j, _len, _len2, _ref, _ref2;
      output = [];
      switch (this.filter) {
        case 'escaped':
          _ref = this.children;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            child = _ref[_i];
            output.push(this.markText(child.render()[0].text, true));
          }
          break;
        case 'preserve':
          preserve = '';
          _ref2 = this.children;
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            child = _ref2[_j];
            preserve += "" + (child.render()[0].text) + "&#x000A;";
          }
          preserve = preserve.replace(/\&\#x000A;$/, '');
          output.push(this.markText(preserve));
          break;
        case 'plain':
          this.renderFilterContent(0, output);
          break;
        case 'css':
          if (this.format === 'html5') {
            output.push(this.markText('<style>'));
          } else {
            output.push(this.markText('<style type=\'text/css\'>'));
          }
          if (this.format === 'xhtml') {
            output.push(this.markText('  /*<![CDATA[*/'));
          }
          indent = this.format === 'xhtml' ? 2 : 1;
          this.renderFilterContent(indent, output);
          if (this.format === 'xhtml') output.push(this.markText('  /*]]>*/'));
          output.push(this.markText('</style>'));
          break;
        case 'javascript':
          if (this.format === 'html5') {
            output.push(this.markText('<script>'));
          } else {
            output.push(this.markText('<script type=\'text/javascript\'>'));
          }
          if (this.format === 'xhtml') output.push(this.markText('  //<![CDATA['));
          indent = this.format === 'xhtml' ? 2 : 1;
          this.renderFilterContent(indent, output);
          if (this.format === 'xhtml') output.push(this.markText('  //]]>'));
          output.push(this.markText('</script>'));
          break;
        case 'cdata':
          output.push(this.markText('<![CDATA['));
          this.renderFilterContent(2, output);
          output.push(this.markText(']]>'));
          break;
        case 'coffeescript':
          this.renderFilterContent(0, output, 'run');
      }
      return output;
    };

    Filter.prototype.renderFilterContent = function(indent, output, type) {
      var child, content, e, empty, line, _i, _j, _len, _len2, _ref, _results;
      if (type == null) type = 'text';
      content = [];
      empty = 0;
      _ref = this.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        content.push(child.render()[0].text);
      }
      _results = [];
      for (_j = 0, _len2 = content.length; _j < _len2; _j++) {
        line = content[_j];
        if (line === '') {
          _results.push(empty += 1);
        } else {
          switch (type) {
            case 'text':
              for (e = 0; 0 <= empty ? e < empty : e > empty; 0 <= empty ? e++ : e--) {
                output.push(this.markText(""));
              }
              output.push(this.markText("" + (w(indent)) + line));
              break;
            case 'run':
              output.push(this.markRunningCode("" + line));
          }
          _results.push(empty = 0);
        }
      }
      return _results;
    };

    return Filter;

  })();

}).call(this);

});

require.define("/compiler.js", function (require, module, exports, __dirname, __filename) {
    (function() {
  var Code, Comment, Compiler, Filter, Haml, Node, Text, w;

  Node = require('./nodes/node');

  Text = require('./nodes/text');

  Haml = require('./nodes/haml');

  Code = require('./nodes/code');

  Comment = require('./nodes/comment');

  Filter = require('./nodes/filter');

  w = require('./helper').whitespace;

  module.exports = Compiler = (function() {

    function Compiler(options) {
      var _base, _base2, _base3, _ref, _ref2, _ref3;
      this.options = options != null ? options : {};
      if ((_ref = (_base = this.options).escapeHtml) == null) {
        _base.escapeHtml = true;
      }
      if ((_ref2 = (_base2 = this.options).escapeAttributes) == null) {
        _base2.escapeAttributes = true;
      }
      if ((_ref3 = (_base3 = this.options).format) == null) {
        _base3.format = 'html5';
      }
    }

    Compiler.prototype.indentChanged = function() {
      return this.currentIndent !== this.previousIndent;
    };

    Compiler.prototype.isIndent = function() {
      return this.currentIndent > this.previousIndent;
    };

    Compiler.prototype.updateTabSize = function() {
      if (this.tabSize === 0) {
        return this.tabSize = this.currentIndent - this.previousIndent;
      }
    };

    Compiler.prototype.updateBlockLevel = function() {
      this.currentBlockLevel = this.currentIndent / this.tabSize;
      if (this.currentBlockLevel - Math.floor(this.currentBlockLevel) > 0) {
        throw "Indentation error in line " + this.lineNumber;
      }
      if ((this.currentIndent - this.previousIndent) / this.tabSize > 1) {
        throw "Block level too deep in line " + this.lineNumber;
      }
      return this.delta = this.previousBlockLevel - this.currentBlockLevel;
    };

    Compiler.prototype.updateCodeBlockLevel = function(node) {
      if (node instanceof Code) {
        return this.currentCodeBlockLevel = node.codeBlockLevel + 1;
      } else {
        return this.currentCodeBlockLevel = node.codeBlockLevel;
      }
    };

    Compiler.prototype.updateParent = function() {
      if (this.isIndent()) {
        return this.pushParent();
      } else {
        return this.popParent();
      }
    };

    Compiler.prototype.pushParent = function() {
      this.stack.push(this.parentNode);
      return this.parentNode = this.node;
    };

    Compiler.prototype.popParent = function() {
      var i, _ref, _results;
      _results = [];
      for (i = 0, _ref = this.delta - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        _results.push(this.parentNode = this.stack.pop());
      }
      return _results;
    };

    Compiler.prototype.getNodeOptions = function(override) {
      if (override == null) override = {};
      return {
        parentNode: override.parentNode || this.parentNode,
        blockLevel: override.blockLevel || this.currentBlockLevel,
        codeBlockLevel: override.codeBlockLevel || this.currentCodeBlockLevel,
        escapeHtml: override.escapeHtml || this.options.escapeHtml,
        escapeAttributes: override.escapeAttributes || this.options.escapeAttributes,
        format: override.format || this.options.format
      };
    };

    Compiler.prototype.nodeFactory = function(expression) {
      var node, options, _ref;
      if (expression == null) expression = '';
      options = this.getNodeOptions();
      if (expression.match(/^:(escaped|preserve|css|javascript|plain|cdata|coffeescript)/)) {
        node = new Filter(expression, options);
      } else if (expression.match(/^(\/|-#)(.*)/)) {
        node = new Comment(expression, options);
      } else if (expression.match(/^(-#|-|=|!=|\&=|~)\s*(.*)/)) {
        node = new Code(expression, options);
      } else if (expression.match(/^(%|#|\.|\!)(.*)/)) {
        node = new Haml(expression, options);
      } else {
        node = new Text(expression, options);
      }
      if ((_ref = options.parentNode) != null) _ref.addChild(node);
      return node;
    };

    Compiler.prototype.parse = function(source) {
      var attributes, expression, line, lines, result, text, whitespace, _ref;
      this.line_number = this.previousIndent = this.tabSize = this.currentBlockLevel = this.previousBlockLevel = 0;
      this.currentCodeBlockLevel = this.previousCodeBlockLevel = 2;
      this.node = null;
      this.stack = [];
      this.root = this.parentNode = new Node('', this.getNodeOptions());
      lines = source.split("\n");
      while ((line = lines.shift()) !== void 0) {
        if ((this.node instanceof Filter) && !this.exitFilter) {
          if (line === '') {
            this.node.addChild(new Text('', this.getNodeOptions({
              parentNode: this.node
            })));
          } else {
            result = line.match(/^(\s*)(.*)/);
            whitespace = result[1];
            expression = result[2];
            if (this.node.blockLevel >= (whitespace.length / 2)) {
              this.exitFilter = true;
              lines.unshift(line);
              continue;
            }
            text = line.match(RegExp("^\\s{" + ((this.node.blockLevel * 2) + 2) + "}(.*)"));
            if (text) {
              this.node.addChild(new Text(text[1], this.getNodeOptions({
                parentNode: this.node
              })));
            }
          }
        } else {
          this.exitFilter = false;
          result = line.match(/^(\s*)(.*)/);
          whitespace = result[1];
          expression = result[2];
          if (line === '') continue;
          while (/^%.*[{(]/.test(expression) && !/^(\s*)[%<]/.test(lines[0]) && /^(\s*).*[})]/.test(lines[0]) && /(?:(['"]?\w+[\w:-]*['"]?)\s*=\s*("(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|[\w@.]+)|(['"]?\w+[\w:-]*['"]?)\s*=>\s*("(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|[-\w@.()'"]+)|(['"]?\w+[\w:-]*['"]?):\s*("(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|[-\w@.()'"]+))/.test(lines[0])) {
            attributes = lines.shift();
            expression += ' ' + attributes.match(/^(\s*)(.*)/)[2];
            this.line_number++;
          }
          if (expression.match(/(\s)+\|$/)) {
            expression = expression.replace(/(\s)+\|$/, ' ');
            while ((_ref = lines[0]) != null ? _ref.match(/(\s)+\|$/) : void 0) {
              expression += lines.shift().match(/^(\s*)(.*)/)[2].replace(/(\s)+\|$/, '');
              this.line_number++;
            }
          }
          this.currentIndent = whitespace.length;
          if (this.indentChanged()) {
            this.updateTabSize();
            this.updateBlockLevel();
            this.updateParent();
            this.updateCodeBlockLevel(this.parentNode);
          }
          this.node = this.nodeFactory(expression);
          this.previousBlockLevel = this.currentBlockLevel;
          this.previousIndent = this.currentIndent;
        }
        this.line_number++;
      }
      return this.evaluate(this.root);
    };

    Compiler.prototype.evaluate = function(node) {
      var child, _i, _len, _ref;
      _ref = node.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        this.evaluate(child);
      }
      return node.evaluate();
    };

    Compiler.prototype.render = function(templateName, namespace) {
      var code, escapeFn, output, segment, segments, _i, _len;
      if (namespace == null) namespace = 'window.HAML';
      output = '';
      segments = ("" + namespace + "." + templateName).replace(/(\s|-)+/g, '_').split(/\./);
      templateName = segments.pop();
      namespace = segments.shift();
      if (segments.length !== 0) {
        for (_i = 0, _len = segments.length; _i < _len; _i++) {
          segment = segments[_i];
          namespace += "." + segment;
          output += "" + namespace + " ?= {}\n";
        }
      } else {
        output += "" + namespace + " ?= {}\n";
      }
      if (this.options.customHtmlEscape) {
        escapeFn = this.options.customHtmlEscape;
      } else {
        escapeFn = "" + namespace + ".htmlEscape";
        output += escapeFn + '||= (text) ->\n  "#{ text }"\n  .replace(/&/g, \'&amp;\')\n  .replace(/</g, \'&lt;\')\n  .replace(/>/g, \'&gt;\')\n  .replace(/\'/g, \'&apos;\')\n  .replace(/\"/g, \'&quot;\')\n';
      }
      output += "" + namespace + "['" + templateName + "'] = (context) ->\n";
      output += "  fn = (context) ->\n";
      output += "    o = []\n";
      output += "    e = " + escapeFn + "\n";
      code = this.createCode();
      output += "" + code + "\n";
      output += "    return o.join(\"\\n\")" + (this.cleanupWhitespace(code)) + "\n";
      output += "  return fn.call(context)";
      return output;
    };

    Compiler.prototype.createCode = function() {
      var child, code, line, _i, _j, _len, _len2, _ref, _ref2;
      code = [];
      this.lines = [];
      _ref = this.root.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        this.lines = this.lines.concat(child.render());
      }
      _ref2 = this.lines;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        line = _ref2[_j];
        if (line !== null) {
          switch (line.type) {
            case 'text':
              code.push("" + (w(line.cw)) + "o.push \"" + (w(line.hw)) + line.text + "\"");
              break;
            case 'run':
              code.push("" + (w(line.cw)) + line.code);
              break;
            case 'insert':
              if (line.hw === 0) {
                code.push("" + (w(line.cw)) + "o.push " + (w(line.escape) ? 'e ' : '') + line.code);
              } else {
                code.push("" + (w(line.cw)) + "o.push " + (w(line.escape) ? 'e' : '') + " \"" + (w(line.hw - line.cw + 2)) + "\" + " + line.code);
              }
          }
        }
      }
      return code.join('\n');
    };

    Compiler.prototype.cleanupWhitespace = function(code) {
      if (/\u0091|\u0092/.test(code)) {
        return ".replace(/[\\s\\n]*\\u0091/mg, '').replace(/\\u0092[\\s\\n]*/mg, '')";
      } else {
        return '';
      }
    };

    return Compiler;

  })();

}).call(this);

});
require("/compiler.js");

