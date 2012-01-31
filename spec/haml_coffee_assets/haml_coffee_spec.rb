require 'spec_helper'

describe HamlCoffeeAssets::HamlCoffee do

  before do
    # Reset configuration to defaults
    HamlCoffeeAssets::HamlCoffee.configure do |c|
      c.namespace = 'window.JST'
      c.format = 'html5'
      c.uglify = false
      c.basename = false
      c.preserveTags = 'textarea,pre'
      c.selfCloseTags = 'meta,img,link,br,hr,input,area,param,col,base'
      c.escapeHtml = true
      c.escapeAttributes = true
      c.cleanValue = true
      c.customHtmlEscape = 'window.HAML.escape'
      c.customCleanValue = 'window.HAML.cleanValue'
      c.customPreserve = 'window.HAML.preserve'
      c.customFindAndPreserve = 'window.HAML.findAndPreserve'
      c.customSurround = 'window.HAML.surround'
      c.customSucceed = 'window.HAML.succeed'
      c.customPrecede = 'window.HAML.precede'
      c.context = ''
    end
    HamlCoffeeAssets::HamlCoffee
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
    return (function() {
      var $o;
      $o = [];
      $o.push("<h2></h2>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
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
    return (function() {
      var $o;
      $o = [];
      $o.push("<script>\\n  var i = 1;\\n</script>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'generates HTML4 documents when configured' do
        subject.configuration.format = 'html4'
        subject.compile('script', ":javascript\n  var i = 1;").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['script'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<script type='text/javascript'>\\n  var i = 1;\\n</script>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'generates XHTML documents when configured' do
        subject.configuration.format = 'xhtml'
        subject.compile('script', ":javascript\n  var i = 1;").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['script'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<script type='text/javascript'>\\n  //<![CDATA[\\n    var i = 1;\\n  //]]>\\n</script>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, " $1='$1'").replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
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
    return (function() {
      var $o;
      $o = [];
      $o.push("<h2></h2>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured namespace' do
        subject.configuration.namespace = 'window.HAML'
        subject.compile('header', '%h2').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }
  window.HAML['header'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h2></h2>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
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
    return (function() {
      var $c, $e, $o;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<h2>" + ($e($c(title))) + "</h2>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured escape function' do
        subject.configuration.customHtmlEscape = 'SomeWhere.escape'
        subject.compile('title', '%h2= title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['title'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = SomeWhere.escape;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<h2>" + ($e($c(title))) + "</h2>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
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
    return (function() {
      var $c, $e, $o;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<h2>" + ($e($c(title))) + "</h2>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured clean value function' do
        subject.configuration.customCleanValue = 'SomeWhere.cleanValue'
        subject.compile('title', '%h2= title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['title'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = window.HAML.escape;
      $c = SomeWhere.cleanValue;
      $o = [];
      $o.push("<h2>" + ($e($c(title))) + "</h2>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
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
    return (function() {
      var $c, $e, $o;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<a title='" + ($e($c(this.title))) + "'></a>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'does not escape the attributes when set to false' do
        subject.configuration.escapeAttributes = false
        subject.compile('attributes', '%a{ :title => @title }').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['attributes'] = function(context) {
    return (function() {
      var $c, $o;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<a title='" + ($c(this.title)) + "'></a>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'Clean value configuration' do
      it 'does clean the values by default' do
        subject.compile('values', '%h1= @title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['values'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<h1>" + ($e($c(this.title))) + "</h1>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'does not clean the values when set to false' do
        subject.configuration.cleanValue = false
        subject.compile('values', '%h1= @title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['values'] = function(context) {
    return (function() {
      var $e, $o;
      $e = window.HAML.escape;
      $o = [];
      $o.push("<h1>" + ($e(this.title)) + "</h1>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
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
    return (function() {
      var $c, $e, $o;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<p>" + ($e($c(this.info))) + "</p>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'does not escape the html when set to false' do
        subject.configuration.escapeHtml = false
        subject.compile('htmlE', '%p= @info').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['htmlE'] = function(context) {
    return (function() {
      var $c, $o;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<p>" + ($c(this.info)) + "</p>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
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
    return (function() {
      var $o;
      $o = [];
      $o.push("<a href='/'></a>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured escape function' do
        subject.configuration.context = 'SomeWhere.context'
        subject.compile('link', '%a{ :href => "/" }').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['link'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a href='/'></a>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(SomeWhere.context(context));
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
    return (function() {
      var $o;
      $o = [];
      $o.push("<html>\\n  <body>\\n    <form>\\n      <input>\\n    </form>\\n  </body>\\n</html>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'does uglify the output when configured' do
        subject.configuration.uglify = true
        subject.compile('ugly', "%html\n  %body\n    %form\n      %input").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['ugly'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<html>\\n<body>\\n<form>\\n<input>\\n</form>\\n</body>\\n</html>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'basename configuration' do
      it 'does not strip the path by default' do
        subject.compile('path/to/file', "%p Basename").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['path/to/file'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<p>Basename</p>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'does strip the path' do
        subject.configuration.basename = true
        subject.compile('path/to/file', "%p Basename").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['file'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<p>Basename</p>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
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
    return (function() {
      var $c, $e, $o, $p;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      $p = window.HAML.preserve;
      $o = [];
      $o.push("<textarea>" + ($p($e($c('Test\\nMe')))) + "</textarea>\\n<pre>" + ($p($e($c('Test\\nMe')))) + "</pre>\\n<p>" + ($e($c('Test\\nMe'))) + "</p>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses any element configured' do
        subject.configuration.preserveTags = 'textarea,p'
        subject.compile('ws', "%textarea= 'Test\\nMe'\n%pre= 'Test\\nMe'\n%p= 'Test\\nMe'\n").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['ws'] = function(context) {
    return (function() {
      var $c, $e, $o, $p;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      $p = window.HAML.preserve;
      $o = [];
      $o.push("<textarea>" + ($p($e($c('Test\\nMe')))) + "</textarea>\\n<pre>" + ($e($c('Test\\nMe'))) + "</pre>\\n<p>" + ($p($e($c('Test\\nMe')))) + "</p>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'autoclose tag list configuration' do
      it 'uses the default list' do
        subject.configuration.format = 'xhtml'
        subject.compile('close', "%img\n%br\n%p\n").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['close'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<img />\\n<br />\\n<p></p>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, " $1='$1'").replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses any element configured' do
        subject.configuration.selfCloseTags = 'br,p'
        subject.configuration.format = 'xhtml'
        subject.compile('close', "%img\n%br\n%p\n").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['close'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<img></img>\\n<br />\\n<p />");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, " $1='$1'").replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
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
    return (function() {
      var $fp, $o, $p;
      $p = window.HAML.preserve;
      $fp = window.HAML.findAndPreserve;
      $o = [];
      $o.push("<h2>" + ($fp(title)) + "</h2>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured preserve function' do
        subject.configuration.customPreserve = 'SomeWhere.preserve'
        subject.compile('pres', '%h2~ title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['pres'] = function(context) {
    return (function() {
      var $fp, $o, $p;
      $p = SomeWhere.preserve;
      $fp = window.HAML.findAndPreserve;
      $o = [];
      $o.push("<h2>" + ($fp(title)) + "</h2>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
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
    return (function() {
      var $fp, $o, $p;
      $p = window.HAML.preserve;
      $fp = window.HAML.findAndPreserve;
      $o = [];
      $o.push("<h2>" + ($fp(title)) + "</h2>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured findAndPreserve function' do
        subject.configuration.customFindAndPreserve = 'SomeWhere.findAndPreserve'
        subject.compile('find', '%h2~ title').should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['find'] = function(context) {
    return (function() {
      var $fp, $o, $p;
      $p = window.HAML.preserve;
      $fp = SomeWhere.findAndPreserve;
      $o = [];
      $o.push("<h2>" + ($fp(title)) + "</h2>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'surround function configuration' do
      it 'uses the default surround function when no custom function is provided' do
        subject.compile('surround', "= surround '(', ')', ->\n  %a{:href => 'food'} chicken").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['surround'] = function(context) {
    return (function() {
      var $c, $e, $o, surround;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      surround = window.HAML.surround;
      $o = [];
      $o.push("" + $e($c(surround('(', ')', function() {
        var $b;
        $b = [];
        $b.push("<a href='food'>chicken</a>");
        return $b.join("\\n");
      }))));
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured surround function' do
        subject.configuration.customSurround = 'SomeWhere.surround'
        subject.compile('surround', "= surround '(', ')', ->\n  %a{:href => 'food'} chicken").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['surround'] = function(context) {
    return (function() {
      var $c, $e, $o, surround;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      surround = SomeWhere.surround;
      $o = [];
      $o.push("" + $e($c(surround('(', ')', function() {
        var $b;
        $b = [];
        $b.push("<a href='food'>chicken</a>");
        return $b.join("\\n");
      }))));
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'succeed function configuration' do
      it 'uses the default succeed function when no custom function is provided' do
        subject.compile('succeed', "click\n= succeed '.', ->\n  %a{:href=>'thing'} here").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['succeed'] = function(context) {
    return (function() {
      var $c, $e, $o, succeed;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      succeed = window.HAML.succeed;
      $o = [];
      $o.push("click");
      $o.push("" + $e($c(succeed('.', function() {
        var $b;
        $b = [];
        $b.push("<a href='thing'>here</a>");
        return $b.join("\\n");
      }))));
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured succeed function' do
        subject.configuration.customSucceed = 'SomeWhere.succeed'
        subject.compile('succeed', "click\n= succeed '.', ->\n  %a{:href=>'thing'} here").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['succeed'] = function(context) {
    return (function() {
      var $c, $e, $o, succeed;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      succeed = SomeWhere.succeed;
      $o = [];
      $o.push("click");
      $o.push("" + $e($c(succeed('.', function() {
        var $b;
        $b = [];
        $b.push("<a href='thing'>here</a>");
        return $b.join("\\n");
      }))));
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    context 'precede function configuration' do
      it 'uses the default precede function when no custom function is provided' do
        subject.compile('precede', "= precede '*', ->\n  %span.small Not really").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['precede'] = function(context) {
    return (function() {
      var $c, $e, $o, precede;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      precede = window.HAML.precede;
      $o = [];
      $o.push("" + $e($c(precede('*', function() {
        var $b;
        $b = [];
        $b.push("<span class='small'>Not really</span>");
        return $b.join("\\n");
      }))));
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'uses a configured precede function' do
        subject.configuration.customPrecede = 'SomeWhere.precede'
        subject.compile('precede', "= precede '*', ->\n  %span.small Not really").should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['precede'] = function(context) {
    return (function() {
      var $c, $e, $o, precede;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      precede = SomeWhere.precede;
      $o = [];
      $o.push("" + $e($c(precede('*', function() {
        var $b;
        $b = [];
        $b.push("<span class='small'>Not really</span>");
        return $b.join("\\n");
      }))));
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end
    end

    describe 'the template creation function' do
      it 'returns the JavaScript template when true' do
        subject.compile('func', '%p', true).should eql <<-TEMPLATE
(function() {
  var _ref;
  if ((_ref = window.JST) == null) {
    window.JST = {};
  }
  window.JST['func'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<p></p>");
      return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'returns only the template function when false' do
        template = <<-TEMPLATE
(function(context) {
  return (function() {
    var $o;
    $o = [];
    $o.push("<p></p>");
    return $o.join("\\n").replace(/\\s(\\w+)='true'/mg, ' $1').replace(/\\s(\\w+)='false'/mg, '');
  }).call(context);
});
        TEMPLATE
        subject.compile('func', '%p', false).should eql template.gsub(/\n$/, '')
      end
    end

    describe 'name_filter' do
      before { HamlCoffeeAssets::HamlCoffeeTemplate.name_filter = nil }
      after  { HamlCoffeeAssets::HamlCoffeeTemplate.name_filter = nil }
        
      it 'should not be used if not set' do
        template = HamlCoffeeAssets::HamlCoffeeTemplate.new { |t| '%h2' }
        scope = Object.new
        scope.stub(:pathname)     { 'templates/foo/bar.htmlc' }
        scope.stub(:logical_path) { 'templates/foo/bar' }
        HamlCoffeeAssets::HamlCoffeeTemplate.name_filter.should be_nil
        HamlCoffeeAssets::HamlCoffee.should_receive(:compile).with('templates/foo/bar', '%h2', true)
        template.render(scope)
      end
      it 'should be used if set' do
        HamlCoffeeAssets::HamlCoffeeTemplate.name_filter = lambda { |n| n.sub /^templates\//, '' }
        template = HamlCoffeeAssets::HamlCoffeeTemplate.new { |t| '%h2' }
        scope = Object.new
        scope.stub(:pathname)     { 'templates/foo/bar.htmlc' }
        scope.stub(:logical_path) { 'templates/foo/bar' }
        HamlCoffeeAssets::HamlCoffee.should_receive(:compile).with('foo/bar', '%h2', true)
        template.render(scope)
      end
      it 'should not be used if name_filter does not match' do
        HamlCoffeeAssets::HamlCoffeeTemplate.name_filter = lambda { |n| n.sub /^templates\//, '' }
        template = HamlCoffeeAssets::HamlCoffeeTemplate.new { |t| '%h2' }
        scope = Object.new
        scope.stub(:pathname)     { 'other/template.htmlc' }
        scope.stub(:logical_path) { 'other/template' }
        HamlCoffeeAssets::HamlCoffee.should_receive(:compile).with('other/template', '%h2', true)
        template.render(scope)
      end
    end

  end
end
