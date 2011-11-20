require 'spec_helper'

describe HamlCoffeeAssets::HamlCoffee do

  before do
    # Reset configuration to defaults
    HamlCoffeeAssets::HamlCoffee.namespace = 'window.JST'
    HamlCoffeeAssets::HamlCoffee.format = 'html5'
    HamlCoffeeAssets::HamlCoffee.escapeHtml = true
    HamlCoffeeAssets::HamlCoffee.escapeAttributes = true
    HamlCoffeeAssets::HamlCoffee.customHtmlEscape = 'window.HAML.escape'
    HamlCoffeeAssets::HamlCoffee.context = ''
  end

  describe "#compile" do
    context 'template name' do
      it 'uses the provided template name' do
        subject.compile('template_name', '%h2').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['template_name'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = window.HAML.escape;
      o.push(\"<h2></h2>\");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'format configuration' do
      it 'uses HTML5 as the default format' do
        subject.compile('script', ":javascript\n  var i = 1;").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['script'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = window.HAML.escape;
      o.push("<script>");
      o.push("  var i = 1;");
      o.push("</script>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'generates HTML4 documents when configured' do
        subject.format = 'html4'
        subject.compile('script', ":javascript\n  var i = 1;").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['script'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = window.HAML.escape;
      o.push("<script type='text/javascript'>");
      o.push("  var i = 1;");
      o.push("</script>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'generates XHTML documents when configured' do
        subject.format = 'xhtml'
        subject.compile('script', ":javascript\n  var i = 1;").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['script'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = window.HAML.escape;
      o.push("<script type='text/javascript'>");
      o.push("  //<![CDATA[");
      o.push("    var i = 1;");
      o.push("  //]]>");
      o.push("</script>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'namespace configuration' do
      it 'uses the default HAML namespace' do
        subject.compile('header', '%h2').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['header'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = window.HAML.escape;
      o.push(\"<h2></h2>\");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured namespace' do
        subject.namespace = 'window.HAML'
        subject.compile('header', '%h2').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }
  window.HAML['header'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = window.HAML.escape;
      o.push(\"<h2></h2>\");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'escape function configuration' do
      it 'uses the default escape function when no custom function is provided' do
        subject.compile('title', '%h2= title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['title'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = window.HAML.escape;
      o.push(\"<h2>\" + (e(title)) + \"</h2>\");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured escape function' do
        subject.customHtmlEscape = 'SomeWhere.escape'
        subject.compile('title', '%h2= title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['title'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = SomeWhere.escape;
      o.push(\"<h2>\" + (e(title)) + \"</h2>\");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'Attribute escaping configuration' do
      it 'does escape the attributes by default' do
        subject.compile('attributes', '%a{ :title => @title }').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['attributes'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = window.HAML.escape;
      o.push("<a title='" + (e(this.title)) + "'></a>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'does not escape the attributes when set to false' do
        subject.escapeAttributes = false
        subject.compile('attributes', '%a{ :title => @title }').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['attributes'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = window.HAML.escape;
      o.push("<a title='" + this.title + "'></a>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'HTML escaping configuration' do
      it 'does escape the html by default' do
        subject.compile('htmlE', '%p= @info }').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['htmlE'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = window.HAML.escape;
      o.push("<p>" + (e(this.info)) + "}</p>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'does not escape the html when set to false' do
        subject.escapeHtml = false
        subject.compile('htmlE', '%p= @info }').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['htmlE'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = window.HAML.escape;
      o.push("<p>" + this.info + "}</p>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'context configuration' do
      it 'does not use the global context without a merge function' do
        subject.compile('link', '%a{ :href => "/" }').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['link'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = window.HAML.escape;
      o.push(\"<a href='/'></a>\");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured escape function' do
        subject.context = 'SomeWhere.context'
        subject.compile('link', '%a{ :href => "/" }').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['link'] = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = window.HAML.escape;
      o.push(\"<a href='/'></a>\");
      return o.join(\"\\n\");
    };
    return fn.call(SomeWhere.context(context));
  };
}).call(this);
        TEMPLATE
      end
    end

  end
end
