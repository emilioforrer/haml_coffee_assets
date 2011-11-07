require 'spec_helper'

describe HamlCoffeeAssets::HamlCoffee do

  before do
    subject.escape    = nil
    subject.namespace = nil
    subject.context   = nil
  end

  describe "#compile" do
    it 'uses the provided template name' do
      subject.compile('template_name', '%h2').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }
  window.HAML.template_name = function(context) {
    var fn;
    fn = function(context) {
      var o;
      o = [];
      o.push("<h2>");
      o.push("</h2>");
      return o.join("\\n");
    };
    return fn.call(context);
  };
}).call(this);
      TEMPLATE
    end

    context 'namespace configuration' do
      it 'uses the default HAML namespace' do
        subject.compile('header', '%h2').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }
  window.HAML.header = function(context) {
    var fn;
    fn = function(context) {
      var o;
      o = [];
      o.push("<h2>");
      o.push("</h2>");
      return o.join("\\n");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured namespace' do
        subject.namespace = 'JST'
        subject.compile('header', '%h2').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST.header = function(context) {
    var fn;
    fn = function(context) {
      var o;
      o = [];
      o.push("<h2>");
      o.push("</h2>");
      return o.join("\\n");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'escape configuration' do
      it 'omits escaping when no escape function is provided' do
        subject.compile('title', '%h2= title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }
  window.HAML.title = function(context) {
    var fn;
    fn = function(context) {
      var o;
      o = [];
      o.push("<h2>" + title);
      o.push("</h2>");
      return o.join("\\n");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured escape function' do
        subject.escape = 'SomeWhere.escape'
        subject.compile('title', '%h2= title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }
  window.HAML.title = function(context) {
    var fn;
    fn = function(context) {
      var e, o;
      o = [];
      e = SomeWhere.escape;
      o.push("<h2>" + (e(title)));
      o.push("</h2>");
      return o.join("\\n");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      context 'context configuration' do
        it 'does not use the global context without a merge function' do
          subject.compile('link', '%a{ :href => "/" }').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }
  window.HAML.link = function(context) {
    var fn;
    fn = function(context) {
      var o;
      o = [];
      o.push("<a href=\\"/\\">");
      o.push("</a>");
      return o.join("\\n");
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
  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }
  window.HAML.link = function(context) {
    var fn;
    fn = function(context) {
      var o;
      o = [];
      o.push("<a href=\\"/\\">");
      o.push("</a>");
      return o.join("\\n");
    };
    return fn.call(SomeWhere.context(context));
  };
}).call(this);
          TEMPLATE
        end
      end

    end
  end
end
