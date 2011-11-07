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
  e = require('../helper').escape;
  w = require('../helper').whitespace;
  module.exports = Node = (function() {
    function Node(expression, block_level, code_block_level) {
      this.expression = expression;
      this.block_level = block_level;
      this.code_block_level = code_block_level;
      this.children = [];
      this.opener = this.closer = "";
      this.cw = w(this.code_block_level);
      this.hw = w(this.block_level - this.code_block_level);
    }
    Node.prototype.addChild = function(child) {
      this.children.push(child);
      return this;
    };
    Node.prototype.getOpener = function() {
      this.evaluateIfNecessary();
      return this.opener;
    };
    Node.prototype.getCloser = function() {
      this.evaluateIfNecessary();
      return this.closer;
    };
    Node.prototype.evaluateIfNecessary = function() {
      if (!this.evaluated) {
        this.evaluate();
      }
      return this.evaluated = true;
    };
    Node.prototype.evaluate = function() {};
    Node.prototype.render = function() {
      var child, output, _i, _len, _ref;
      output = "" + (this.getOpener()) + "\n";
      _ref = this.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        output += "" + (child.render());
      }
      if (this.getCloser().length > 0) {
        output += "" + (this.getCloser()) + "\n";
      }
      return output;
    };
    return Node;
  })();
}).call(this);

});

require.define("/helper.js", function (require, module, exports, __dirname, __filename) {
    (function() {
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
    escape: function(s) {
      return s.replace(/"/g, '\\"');
    }
  };
}).call(this);

});

require.define("/nodes/text.js", function (require, module, exports, __dirname, __filename) {
    (function() {
  var Node, Text;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Node = require('./node');
  module.exports = Text = (function() {
    __extends(Text, Node);
    function Text() {
      Text.__super__.constructor.apply(this, arguments);
    }
    Text.prototype.evaluate = function() {
      return this.opener = "" + this.cw + "o.push \"" + this.hw + this.expression + "\"";
    };
    return Text;
  })();
}).call(this);

});

require.define("/nodes/haml.js", function (require, module, exports, __dirname, __filename) {
    (function() {
  var Haml, Node, qe;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Node = require('./node');
  qe = require('../helper').escape;
  module.exports = Haml = (function() {
    __extends(Haml, Node);
    Haml.selfCloseTags = ["meta", "img", "link", "br", "hr", "input", "area", "base"];
    function Haml(expression, block_level, code_block_level, escape_html) {
      this.escape_html = escape_html;
      Haml.__super__.constructor.call(this, expression, block_level, code_block_level);
    }
    Haml.prototype.evaluate = function() {
      var htmlTagPrefix, parsedExpression;
      parsedExpression = this.parseExpression(this.expression);
      htmlTagPrefix = this.buildHtmlTag(parsedExpression);
      if (this.isSelfClosing(parsedExpression.tag)) {
        this.opener = "" + this.cw + "o.push \"" + this.hw + (qe(htmlTagPrefix)) + ">";
        this.closer = "" + this.cw + "o.push \"" + this.hw + "</" + parsedExpression.tag + ">\"";
      } else {
        this.opener = "" + this.cw + "o.push \"" + this.hw + (qe(htmlTagPrefix)) + " />";
      }
      if (parsedExpression.assignment) {
        this.opener += this.escape_html ? "\#{e " + parsedExpression.assignment + "}" : "\#{" + parsedExpression.assignment + "}";
      }
      return this.opener += '"';
    };
    Haml.prototype.parseExpression = function(exp) {
      var optionProperties, tagProperties;
      tagProperties = this.parseTag(exp);
      optionProperties = this.parseOptions(exp);
      return {
        tag: tagProperties.tag,
        ids: tagProperties.ids,
        classes: tagProperties.classes,
        pairs: optionProperties.pairs,
        assignment: optionProperties.assignment
      };
    };
    Haml.prototype.buildHtmlTag = function(parsedExpression) {
      var pair, tagParts, _i, _len, _ref;
      tagParts = ["<" + parsedExpression.tag];
      if (parsedExpression.ids) {
        tagParts.push("id=\"" + (parsedExpression.ids.join(' ')) + "\"");
      }
      if (parsedExpression.classes) {
        tagParts.push("class=\"" + (parsedExpression.classes.join(' ')) + "\"");
      }
      if (parsedExpression.pairs.length > 0) {
        _ref = parsedExpression.pairs;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          pair = _ref[_i];
          tagParts.push("" + pair.key + "=" + pair.value);
        }
      }
      return tagParts.join(' ');
    };
    Haml.prototype.parseTag = function(exp) {
      var classes, id, ids, klass, tag, tagExp;
      try {
        tagExp = exp.match(/^((?:[.#%][a-z_\-][a-z0-9_:\-]*)+)(.*)$/i)[1];
        tag = tagExp.match(/\%([a-z_\-][a-z0-9_:\-]*)/i);
        tag = tag ? tag[1] : 'div';
        ids = tagExp.match(/\#([a-z_\-][a-z0-9_\-]*)/gi);
        classes = tagExp.match(/\.([a-z_\-][a-z0-9_\-]*)/gi);
        return {
          tag: tag,
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
          })() : void 0
        };
      } catch (error) {
        throw "Unable to parse tag from " + exp + ": " + error;
      }
    };
    Haml.prototype.parseOptions = function(exp) {
      var assignment, attributesExp, optionsExp, pairs;
      optionsExp = exp.match(/[\{\s=].*/i);
      if (optionsExp) {
        optionsExp = optionsExp[0];
        if (optionsExp[0] === "{") {
          attributesExp = optionsExp.match(/\{(.*)\}/);
          if (attributesExp) {
            attributesExp = attributesExp[1];
          }
          assignment = optionsExp.match(/\{.*\}\s*=\s*(.*)/);
        } else {
          assignment = optionsExp.match(/\.*=\s*(.*)/);
        }
        if (assignment) {
          assignment = assignment[1];
        }
        pairs = this.parseAttributes(attributesExp);
      }
      return {
        assignment: assignment,
        pairs: pairs || []
      };
    };
    Haml.prototype.parseAttributes = function(attributesExp) {
      var attribute, attributes, key, pair, pairs, result, value, valueIsLiteral, _i, _len;
      pairs = [];
      if (attributesExp == null) {
        return pairs;
      }
      attributes = attributesExp.match(/(:[^\s|=]+\s*=>\s*(("[^"]+")|('[^']+')|[^\s]+))/g);
      for (_i = 0, _len = attributes.length; _i < _len; _i++) {
        attribute = attributes[_i];
        pair = attribute.split('=>');
        key = pair[0].trim().substr(1);
        result = key.match(/^'(.+)'$/);
        if (result) {
          key = result[1];
        }
        value = pair[1].trim();
        valueIsLiteral = value.match(/^("|').*\1$/);
        value = value.replace(/,$/, '');
        pairs.push({
          key: key,
          value: valueIsLiteral ? value : '"#{' + value + '}"'
        });
      }
      return pairs;
    };
    Haml.prototype.isSelfClosing = function(tag) {
      return Haml.selfCloseTags.indexOf(tag) === -1;
    };
    return Haml;
  })();
}).call(this);

});

require.define("/nodes/code.js", function (require, module, exports, __dirname, __filename) {
    (function() {
  var Code, Node, e;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Node = require('./node');
  e = require('../helper').escape;
  module.exports = Code = (function() {
    __extends(Code, Node);
    function Code(expression, block_level, code_block_level, escape_html) {
      this.escape_html = escape_html;
      Code.__super__.constructor.call(this, expression, block_level, code_block_level);
    }
    Code.prototype.evaluate = function() {
      var code, expression, identifier, _ref;
      _ref = this.expression.match(/(-|!=|=)\s(.*)/), expression = _ref[0], identifier = _ref[1], code = _ref[2];
      return this.opener = identifier === '-' ? "" + this.cw + code : identifier === '!=' || !this.escape_html ? "" + this.cw + "o.push \"" + this.hw + "\#{" + code + "}\"" : "" + this.cw + "o.push e \"" + this.hw + "\#{" + code + "}\"";
    };
    return Code;
  })();
}).call(this);

});

require.define("/compiler.js", function (require, module, exports, __dirname, __filename) {
    (function() {
  var Code, Compiler, Haml, Node, Text;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Node = require('./nodes/node');
  Text = require('./nodes/text');
  Haml = require('./nodes/haml');
  Code = require('./nodes/code');
  module.exports = Compiler = (function() {
    function Compiler(options) {
      var _base, _ref;
      this.options = options != null ? options : {};
      if ((_ref = (_base = this.options).escape_html) == null) {
        _base.escape_html = true;
      }
    }
    Compiler.prototype.node_factory = function(expression, current_block_level, current_code_block_level) {
      var node;
      if (expression.match(/^(-|=|!=)\s*(.*)/)) {
        node = new Code(expression, current_block_level, current_code_block_level, this.options.escape_html);
      } else if (expression.match(/^(%|#|\.)(.*)/)) {
        node = new Haml(expression, current_block_level, current_code_block_level, this.options.escape_html);
      } else {
        node = new Text(expression, current_block_level, current_code_block_level);
      }
      return node;
    };
    Compiler.prototype.update_code_block_level = function(node) {
      if (node instanceof Code) {
        return this.current_code_block_level = node.code_block_level + 1;
      } else {
        return this.current_code_block_level = node.code_block_level;
      }
    };
    Compiler.prototype.indent_changed = function() {
      return this.current_indent !== this.previous_indent;
    };
    Compiler.prototype.is_indent = function() {
      return this.current_indent > this.previous_indent;
    };
    Compiler.prototype.update_tab_size = function() {
      if (this.tab_size === 0) {
        return this.tab_size = this.current_indent - this.previous_indent;
      }
    };
    Compiler.prototype.update_block_level = function() {
      this.current_block_level = this.current_indent / this.tab_size;
      if (this.current_block_level - Math.floor(this.current_block_level) > 0) {
        throw "Indentation error in line " + this.line_number;
      }
      if ((this.current_indent - this.previous_indent) / this.tab_size > 1) {
        throw "Block level too deep in line " + this.line_number;
      }
      return this.delta = this.previous_block_level - this.current_block_level;
    };
    Compiler.prototype.push_parent = function() {
      this.stack.push(this.parent_node);
      return this.parent_node = this.node;
    };
    Compiler.prototype.pop_parent = function() {
      var i, _ref, _results;
      _results = [];
      for (i = 0, _ref = this.delta - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        _results.push(this.parent_node = this.stack.pop());
      }
      return _results;
    };
    Compiler.prototype.parse = function(source) {
      this.line_number = 0;
      this.previous_indent = 0;
      this.tab_size = 0;
      this.current_block_level = this.previous_block_level = 0;
      this.current_code_block_level = this.previous_code_block_level = 2;
      this.root = this.parent_node = new Node("", this.current_block_level, this.current_code_block_level);
      this.node = null;
      this.stack = [];
      return source.split("\n").forEach(__bind(function(line) {
        var expression, result, whitespace;
        result = line.match(/^(\s*)(.*)/);
        whitespace = result[1];
        expression = result[2];
        if (expression.length > 0) {
          if (!expression.match(/^\//)) {
            this.current_indent = whitespace.length;
            if (this.indent_changed()) {
              this.update_tab_size();
              this.update_block_level();
              if (this.is_indent()) {
                this.push_parent();
              } else {
                this.pop_parent();
              }
              this.update_code_block_level(this.parent_node);
            }
            this.node = this.node_factory(expression, this.current_block_level, this.current_code_block_level);
            this.parent_node.addChild(this.node);
            this.previous_block_level = this.current_block_level;
            this.previous_indent = this.current_indent;
            this.line_number++;
          }
        }
      }, this));
    };
    Compiler.prototype.parameterize = function(s) {
      s = s.replace(/(\s|-)+/g, "_");
      return s;
    };
    Compiler.prototype.render = function(filename, namespace) {
      var html_escape_function_name, name, output, segment, segments, _i, _len;
      if (namespace == null) {
        namespace = "HAML";
      }
      output = "window." + namespace + " ?= {}\n";
      if (this.options.escape_html) {
        if (this.options.custom_html_escape) {
          html_escape_function_name = this.options.custom_html_escape;
        } else {
          html_escape_function_name = "window." + namespace + ".html_escape";
          output += html_escape_function_name + '||= (text) ->\n  "#{text}"\n  .replace(/&/g, "&amp;")\n  .replace(/</g, "&lt;")\n  .replace(/>/g, "&gt;")\n  .replace(/\"/g, "&quot;")\n';
        }
      }
      segments = this.parameterize(filename).split('/');
      name = segments.pop();
      for (_i = 0, _len = segments.length; _i < _len; _i++) {
        segment = segments[_i];
        namespace += "." + segment;
        output += "window." + namespace + " ?= {}\n";
      }
      output += "window." + namespace + "." + name + " = (context) ->\n";
      output += "  fn = (context) ->\n";
      output += "    o = []";
      if (this.options.escape_html) {
        output += "\n    e = " + html_escape_function_name;
      }
      output += this.root.render();
      output += "    return o.join(\"\\n\")\n";
      output += "  return fn.call(context)\n";
      return output;
    };
    return Compiler;
  })();
}).call(this);

});
require("/compiler.js");

