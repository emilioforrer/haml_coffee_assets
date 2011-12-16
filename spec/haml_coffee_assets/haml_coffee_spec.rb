require 'spec_helper'

describe HamlCoffeeAssets::HamlCoffee do

  before do
    # Reset configuration to defaults
    HamlCoffeeAssets::HamlCoffee.namespace = 'window.JST'
    HamlCoffeeAssets::HamlCoffee.format = 'html5'
    HamlCoffeeAssets::HamlCoffee.uglify = false
    HamlCoffeeAssets::HamlCoffee.basename = false
    HamlCoffeeAssets::HamlCoffee.preserveTags = 'textarea,pre'
    HamlCoffeeAssets::HamlCoffee.selfCloseTags = 'meta,img,link,br,hr,input,area,param,col,base'
    HamlCoffeeAssets::HamlCoffee.escapeHtml = true
    HamlCoffeeAssets::HamlCoffee.escapeAttributes = true
    HamlCoffeeAssets::HamlCoffee.cleanValue = true
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
    return (function() {
      var $o;
      $o = [];
      $o.push("<h2></h2>");
      return $o.join("\\n");
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
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $o;
      $o = [];
      $o.push("<script type='text/javascript'>\\n  var i = 1;\\n</script>");
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $o;
      $o = [];
      $o.push("<script type='text/javascript'>\\n  //<![CDATA[\\n    var i = 1;\\n  //]]>\\n</script>");
      return $o.join("\\n");
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
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $o;
      $o = [];
      $o.push("<h2></h2>");
      return $o.join("\\n");
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
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $c, $e, $o;
      $e = SomeWhere.escape;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<h2>" + ($e($c(title))) + "</h2>");
      return $o.join("\\n");
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
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $c, $e, $o;
      $e = window.HAML.escape;
      $c = SomeWhere.cleanValue;
      $o = [];
      $o.push("<h2>" + ($e($c(title))) + "</h2>");
      return $o.join("\\n");
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
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $c, $o;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<a title='" + ($c(this.title)) + "'></a>");
      return $o.join("\\n");
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
      return $o.join("\\n");
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'does not clean the values when set to false' do
        subject.cleanValue = false
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
      return $o.join("\\n");
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
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $c, $o;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<p>" + ($c(this.info)) + "</p>");
      return $o.join("\\n");
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
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $o;
      $o = [];
      $o.push("<a href='/'></a>");
      return $o.join("\\n");
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
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $o;
      $o = [];
      $o.push("<html>\\n<body>\\n<form>\\n<input>\\n</form>\\n</body>\\n</html>");
      return $o.join("\\n");
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
      return $o.join("\\n");
    }).call(context);
  };
}).call(this);
        TEMPLATE
      end

      it 'does strip the path' do
        subject.basename = true
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
      return $o.join("\\n");
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
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $c, $e, $o, $p;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      $p = window.HAML.preserve;
      $o = [];
      $o.push("<textarea>" + ($p($e($c('Test\\nMe')))) + "</textarea>\\n<pre>" + ($e($c('Test\\nMe'))) + "</pre>\\n<p>" + ($p($e($c('Test\\nMe')))) + "</p>");
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $o;
      $o = [];
      $o.push("<img />\\n<br />\\n<p></p>");
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $o;
      $o = [];
      $o.push("<img></img>\\n<br />\\n<p />");
      return $o.join("\\n");
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
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $fp, $o, $p;
      $p = SomeWhere.preserve;
      $fp = window.HAML.findAndPreserve;
      $o = [];
      $o.push("<h2>" + ($fp(title)) + "</h2>");
      return $o.join("\\n");
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
      return $o.join("\\n");
    }).call(context);
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
    return (function() {
      var $fp, $o, $p;
      $p = window.HAML.preserve;
      $fp = SomeWhere.findAndPreserve;
      $o = [];
      $o.push("<h2>" + ($fp(title)) + "</h2>");
      return $o.join("\\n");
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
      return $o.join("\\n");
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
    return $o.join("\\n");
  }).call(context);
});
        TEMPLATE
        subject.compile('func', '%p', false).should eql template.gsub(/\n$/, '')
      end
    end
  end
end
