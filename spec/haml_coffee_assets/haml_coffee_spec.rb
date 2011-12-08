require 'spec_helper'

describe HamlCoffeeAssets::HamlCoffee do

  before do
    # Reset configuration to defaults
    HamlCoffeeAssets::HamlCoffee.namespace = 'window.JST'
    HamlCoffeeAssets::HamlCoffee.format = 'html5'
    HamlCoffeeAssets::HamlCoffee.uglify = false
    HamlCoffeeAssets::HamlCoffee.preserveTags = 'textarea,pre'
    HamlCoffeeAssets::HamlCoffee.selfCloseTags = 'meta,img,link,br,hr,input,area,param,col,base'
    HamlCoffeeAssets::HamlCoffee.escapeHtml = true
    HamlCoffeeAssets::HamlCoffee.escapeAttributes = true
    HamlCoffeeAssets::HamlCoffee.customHtmlEscape = 'window.HAML.escape'
    HamlCoffeeAssets::HamlCoffee.customCleanValue = 'window.HAML.cleanValue'
    HamlCoffeeAssets::HamlCoffee.customPreserve = 'window.HAML.preserve'
    HamlCoffeeAssets::HamlCoffee.customFindAndPreserve = 'window.HAML.findAndPreserve'
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
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
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
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
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
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
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
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
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
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
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
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
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
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push(\"<h2>\" + (e(c(title))) + \"</h2>\");
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
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = SomeWhere.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push(\"<h2>\" + (e(c(title))) + \"</h2>\");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'clean value function configuration' do
      it 'uses the default clean value function when no custom function is provided' do
        subject.compile('title', '%h2= title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['title'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push(\"<h2>\" + (e(c(title))) + \"</h2>\");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured clean value function' do
        subject.customCleanValue = 'SomeWhere.cleanValue'
        subject.compile('title', '%h2= title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['title'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = SomeWhere.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push(\"<h2>\" + (e(c(title))) + \"</h2>\");
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
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push("<a title='" + (e(c(this.title))) + "'></a>");
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
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push("<a title='" + (c(this.title)) + "'></a>");
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
        subject.compile('htmlE', '%p= @info').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['htmlE'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push("<p>" + (e(c(this.info))) + "</p>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'does not escape the html when set to false' do
        subject.escapeHtml = false
        subject.compile('htmlE', '%p= @info').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['htmlE'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push("<p>" + (c(this.info)) + "</p>");
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
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
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
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push(\"<a href='/'></a>\");
      return o.join(\"\\n\");
    };
    return fn.call(SomeWhere.context(context));
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'uglify configuration' do
      it 'does not uglify by default' do
        subject.compile('ugly', "%html\n  %body\n    %form\n      %input").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['ugly'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push("<html>");
      o.push("  <body>");
      o.push("    <form>");
      o.push("      <input>");
      o.push("    </form>");
      o.push("  </body>");
      o.push("</html>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'does uglify the output when configured' do
        subject.uglify = true
        subject.compile('ugly', "%html\n  %body\n    %form\n      %input").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['ugly'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push("<html>");
      o.push("<body>");
      o.push("<form>");
      o.push("<input>");
      o.push("</form>");
      o.push("</body>");
      o.push("</html>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'whitespace tag list configuration' do
      it 'uses textarea and pre by default' do
        subject.compile('ws', "%textarea= 'Test\\nMe'\n%pre= 'Test\\nMe'\n%p= 'Test\\nMe'\n").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['ws'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push("<textarea>" + (p(e(c('Test\\nMe')))) + "</textarea>");
      o.push("<pre>" + (p(e(c('Test\\nMe')))) + "</pre>");
      o.push("<p>" + (e(c('Test\\nMe'))) + "</p>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses any element configured' do
        subject.preserveTags = 'textarea,p'
        subject.compile('ws', "%textarea= 'Test\\nMe'\n%pre= 'Test\\nMe'\n%p= 'Test\\nMe'\n").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['ws'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push("<textarea>" + (p(e(c('Test\\nMe')))) + "</textarea>");
      o.push("<pre>" + (e(c('Test\\nMe'))) + "</pre>");
      o.push("<p>" + (p(e(c('Test\\nMe')))) + "</p>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'autoclose tag list configuration' do
      it 'uses the default list' do
        subject.format = 'xhtml'
        subject.compile('close', "%img\n%br\n%p\n").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['close'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push("<img />");
      o.push("<br />");
      o.push("<p></p>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses any element configured' do
        subject.selfCloseTags = 'br,p'
        subject.format = 'xhtml'
        subject.compile('close', "%img\n%br\n%p\n").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['close'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push("<img></img>");
      o.push("<br />");
      o.push("<p />");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'preserve function configuration' do
      it 'uses the default preserve function when no custom function is provided' do
        subject.compile('pres', '%h2~ title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['pres'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push("<h2>" + (fp(title)) + "</h2>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured preserve function' do
        subject.customPreserve = 'SomeWhere.preserve'
        subject.compile('pres', '%h2~ title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['pres'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = SomeWhere.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push("<h2>" + (fp(title)) + "</h2>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'findAndPreserve function configuration' do
      it 'uses the default findAndPreserve function when no custom function is provided' do
        subject.compile('find', '%h2~ title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['find'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = window.HAML.findAndPreserve;
      o.push("<h2>" + (fp(title)) + "</h2>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured findAndPreserve function' do
        subject.customFindAndPreserve = 'SomeWhere.findAndPreserve'
        subject.compile('find', '%h2~ title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['find'] = function(context) {
    var fn;
    fn = function(context) {
      var c, e, findAndPreserve, fp, o, p;
      o = [];
      e = window.HAML.escape;
      c = window.HAML.cleanValue;
      p = window.HAML.preserve;
      fp = findAndPreserve = SomeWhere.findAndPreserve;
      o.push("<h2>" + (fp(title)) + "</h2>");
      return o.join(\"\\n\");
    };
    return fn.call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

  end
end
