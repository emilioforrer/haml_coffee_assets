# encoding: utf-8

require 'spec_helper'

describe HamlCoffeeAssets::Compiler do

  before do
    HamlCoffeeAssets.instance_variable_set '@config', HamlCoffeeAssets::Configuration.new
  end

  describe '#compile' do
    context 'template name' do
      it 'uses the provided template name' do
        expect(HamlCoffeeAssets::Compiler.compile('template_name', '%h2')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['template_name'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h2></h2>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'format configuration' do
      it 'uses HTML5 as the default format' do
        expect(HamlCoffeeAssets::Compiler.compile('script', ":javascript\n  var i = 1;")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['script'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<script>\\n  var i = 1;\\n</script>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'generates HTML4 documents when configured' do
        HamlCoffeeAssets.config.format = 'html4'
        expect(HamlCoffeeAssets::Compiler.compile('script', ":javascript\n  var i = 1;")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['script'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<script type='text/javascript'>\\n  var i = 1;\\n</script>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'generates XHTML documents when configured' do
        HamlCoffeeAssets.config.format = 'xhtml'
        expect(HamlCoffeeAssets::Compiler.compile('script', ":javascript\n  var i = 1;")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['script'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<script type='text/javascript'>\\n  //<![CDATA[\\n    var i = 1;\\n  //]]>\\n</script>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'namespace configuration' do
      it 'uses the default HAML namespace' do
        expect(HamlCoffeeAssets::Compiler.compile('header', '%h2')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['header'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h2></h2>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'uses a configured namespace' do
        HamlCoffeeAssets.config.namespace = 'window.HAML'
        expect(HamlCoffeeAssets::Compiler.compile('header', '%h2')).to eql <<-TEMPLATE
(function() {
  if (window.HAML == null) {
    window.HAML = {};
  }

  window.HAML['header'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<h2></h2>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'escape function configuration' do
      it 'uses the default escape function when no custom function is provided' do
        expect(HamlCoffeeAssets::Compiler.compile('title', '%h2= title')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['title'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<h2>" + ($e($c(title))) + "</h2>");
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'uses a configured escape function' do
        HamlCoffeeAssets.config.customHtmlEscape = 'SomeWhere.escape'
        expect(HamlCoffeeAssets::Compiler.compile('title', '%h2= title')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['title'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = SomeWhere.escape;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<h2>" + ($e($c(title))) + "</h2>");
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'clean value function configuration' do
      it 'uses the default clean value function when no custom function is provided' do
        expect(HamlCoffeeAssets::Compiler.compile('title', '%h2= title')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['title'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<h2>" + ($e($c(title))) + "</h2>");
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'uses a configured clean value function' do
        HamlCoffeeAssets.config.customCleanValue = 'SomeWhere.cleanValue'
        expect(HamlCoffeeAssets::Compiler.compile('title', '%h2= title')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['title'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = window.HAML.escape;
      $c = SomeWhere.cleanValue;
      $o = [];
      $o.push("<h2>" + ($e($c(title))) + "</h2>");
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'placement configuration' do
      it 'uses the global placement by default' do
        expect(HamlCoffeeAssets::Compiler.compile('placement', '%p Global placement')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['placement'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<p>Global placement</p>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'wraps the function within a define function with the amd placement' do
        HamlCoffeeAssets.config.placement = 'amd'
        expect(HamlCoffeeAssets::Compiler.compile('placement', '%p AMD placement')).to eql <<-TEMPLATE
(function() {
  define(['hamlcoffee_amd'], function(hc) {
    return function(context) {
      var render;
      render = function() {
        var $o;
        $o = [];
        $o.push("<p>AMD placement</p>");
        return $o.join("\\n");
      };
      return render.call(hc.context(context));
    };
  });

}).call(this);
        TEMPLATE
      end
    end

    context 'global amd module dependencies' do
      it 'adds the hamlcoffee module context helper' do
        HamlCoffeeAssets.config.placement = 'amd'
        expect(HamlCoffeeAssets::Compiler.compile('globals', '%p AMD module dependencies')).to eql <<-TEMPLATE
(function() {
  define(['hamlcoffee_amd'], function(hc) {
    return function(context) {
      var render;
      render = function() {
        var $o;
        $o = [];
        $o.push("<p>AMD module dependencies</p>");
        return $o.join("\\n");
      };
      return render.call(hc.context(context));
    };
  });

}).call(this);
        TEMPLATE
      end

      it 'adds the module dependencies' do
        HamlCoffeeAssets.config.placement = 'amd'
        HamlCoffeeAssets.config.dependencies = { '_' => 'underscore' }
        expect(HamlCoffeeAssets::Compiler.compile('globals', '%p AMD module dependencies')).to eql <<-TEMPLATE
(function() {
  define(['underscore'], function(_) {
    return function(context) {
      var render;
      render = function() {
        var $o;
        $o = [];
        $o.push("<p>AMD module dependencies</p>");
        return $o.join("\\n");
      };
      return render.call(context);
    };
  });

}).call(this);
        TEMPLATE
      end

      it 'adds the template dependencies' do
        HamlCoffeeAssets.config.placement = 'amd'
        expect(HamlCoffeeAssets::Compiler.compile('partials', "%p!= require('shared/partial')()")).to eql <<-TEMPLATE
(function() {
  define(['hamlcoffee_amd', 'shared/partial'], function(hc, partial) {
    return function(context) {
      var render;
      render = function() {
        var $c, $o;
        $c = hc.cleanValue;
        $o = [];
        $o.push("<p>" + ($c(require('shared/partial')())) + "</p>");
        return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace\(/\\s([\\w-]+)='false'/mg, '');
      };
      return render.call(hc.context(context));
    };
  });

}).call(this);
        TEMPLATE
      end
    end

    context 'Attribute escaping configuration' do
      it 'does escape the attributes by default' do
        expect(HamlCoffeeAssets::Compiler.compile('attributes', '%a{ :title => @title }')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['attributes'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<a title='" + ($e($c(this.title))) + "'></a>");
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace\(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'does not escape the attributes when set to false' do
        HamlCoffeeAssets.config.escapeAttributes = false
        expect(HamlCoffeeAssets::Compiler.compile('attributes', '%a{ :title => @title }')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['attributes'] = function(context) {
    return (function() {
      var $c, $o;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<a title='" + ($c(this.title)) + "'></a>");
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'Clean value configuration' do
      it 'does clean the values by default' do
        expect(HamlCoffeeAssets::Compiler.compile('values', '%h1= @title')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['values'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<h1>" + ($e($c(this.title))) + "</h1>");
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'does not clean the values when set to false' do
        HamlCoffeeAssets.config.cleanValue = false
        expect(HamlCoffeeAssets::Compiler.compile('values', '%h1= @title')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['values'] = function(context) {
    return (function() {
      var $e, $o;
      $e = window.HAML.escape;
      $o = [];
      $o.push("<h1>" + ($e(this.title)) + "</h1>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'HTML escaping configuration' do
      it 'does escape the html by default' do
        expect(HamlCoffeeAssets::Compiler.compile('htmlE', '%p= @info')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['htmlE'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<p>" + ($e($c(this.info))) + "</p>");
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'does not escape the html when set to false' do
        HamlCoffeeAssets.config.escapeHtml = false
        expect(HamlCoffeeAssets::Compiler.compile('htmlE', '%p= @info')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['htmlE'] = function(context) {
    return (function() {
      var $c, $o;
      $c = window.HAML.cleanValue;
      $o = [];
      $o.push("<p>" + ($c(this.info)) + "</p>");
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'context configuration' do
      it 'uses the default context function' do
        expect(HamlCoffeeAssets::Compiler.compile('link', '%a{ :href => "/" }')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['link'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a href='/'></a>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'does not use the global context without a merge function' do
        HamlCoffeeAssets.config.context = false
        expect(HamlCoffeeAssets::Compiler.compile('link', '%a{ :href => "/" }')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
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

      it 'uses a configured context function' do
        HamlCoffeeAssets.config.context = 'SomeWhere.context'
        expect(HamlCoffeeAssets::Compiler.compile('link', '%a{ :href => "/" }')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
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
        expect(HamlCoffeeAssets::Compiler.compile('ugly', "%html\n  %body\n    %form\n      %input")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['ugly'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<html>\\n  <body>\\n    <form>\\n      <input>\\n    </form>\\n  </body>\\n</html>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'does uglify the output when configured' do
        HamlCoffeeAssets.config.uglify = true
        expect(HamlCoffeeAssets::Compiler.compile('ugly', "%html\n  %body\n    %form\n      %input")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['ugly'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<html>\\n<body>\\n<form>\\n<input>\\n</form>\\n</body>\\n</html>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'basename configuration' do
      it 'does not strip the path by default' do
        expect(HamlCoffeeAssets::Compiler.compile('path/to/file', "%p Basename")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['path/to/file'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<p>Basename</p>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'does strip the path' do
        HamlCoffeeAssets.config.basename = true
        expect(HamlCoffeeAssets::Compiler.compile('path/to/file', "%p Basename")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['file'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<p>Basename</p>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'whitespace tag list configuration' do
      it 'uses textarea and pre by default' do
        expect(HamlCoffeeAssets::Compiler.compile('ws', "%textarea= 'Test\\nMe'\n%pre= 'Test\\nMe'\n%p= 'Test\\nMe'\n")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
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
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'uses any element configured' do
        HamlCoffeeAssets.config.preserveTags = 'textarea,p'
        expect(HamlCoffeeAssets::Compiler.compile('ws', "%textarea= 'Test\\nMe'\n%pre= 'Test\\nMe'\n%p= 'Test\\nMe'\n")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
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
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'autoclose tag list configuration' do
      it 'uses the default list' do
        HamlCoffeeAssets.config.format = 'xhtml'
        expect(HamlCoffeeAssets::Compiler.compile('close', "%img\n%br\n%p\n")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['close'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<img />\\n<br />\\n<p></p>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'uses any element configured' do
        HamlCoffeeAssets.config.selfCloseTags = 'br,p'
        HamlCoffeeAssets.config.format = 'xhtml'
        expect(HamlCoffeeAssets::Compiler.compile('close', "%img\n%br\n%p\n")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['close'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<img></img>\\n<br />\\n<p />");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'preserve function configuration' do
      it 'uses the default preserve function when no custom function is provided' do
        expect(HamlCoffeeAssets::Compiler.compile('pres', '%h2~ title')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
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
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'uses a configured preserve function' do
        HamlCoffeeAssets.config.customPreserve = 'SomeWhere.preserve'
        expect(HamlCoffeeAssets::Compiler.compile('pres', '%h2~ title')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
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
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'findAndPreserve function configuration' do
      it 'uses the default findAndPreserve function when no custom function is provided' do
        expect(HamlCoffeeAssets::Compiler.compile('find', '%h2~ title')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
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
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'uses a configured findAndPreserve function' do
        HamlCoffeeAssets.config.customFindAndPreserve = 'SomeWhere.findAndPreserve'
        expect(HamlCoffeeAssets::Compiler.compile('find', '%h2~ title')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
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
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'surround function configuration' do
      it 'uses the default surround function when no custom function is provided' do
        expect(HamlCoffeeAssets::Compiler.compile('surround', "= surround '(', ')', ->\n  %a{:href => 'food'} chicken")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['surround'] = function(context) {
    return (function() {
      var $c, $e, $o, surround;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      surround = (function(_this) {
        return function(start, end, fn) {
          return window.HAML.surround.call(_this, start, end, fn);
        };
      })(this);
      $o = [];
      $o.push("" + $e($c(surround('(', ')', function() {
        var $o1;
        $o1 = [];
        $o1.push("<a href='food'>chicken</a>");
        return $o1.join("\\n");
      }))));
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'uses a configured surround function' do
        HamlCoffeeAssets.config.customSurround = 'SomeWhere.surround'
        expect(HamlCoffeeAssets::Compiler.compile('surround', "= surround '(', ')', ->\n  %a{:href => 'food'} chicken")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['surround'] = function(context) {
    return (function() {
      var $c, $e, $o, surround;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      surround = (function(_this) {
        return function(start, end, fn) {
          return SomeWhere.surround.call(_this, start, end, fn);
        };
      })(this);
      $o = [];
      $o.push("" + $e($c(surround('(', ')', function() {
        var $o1;
        $o1 = [];
        $o1.push("<a href='food'>chicken</a>");
        return $o1.join("\\n");
      }))));
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'succeed function configuration' do
      it 'uses the default succeed function when no custom function is provided' do
        expect(HamlCoffeeAssets::Compiler.compile('succeed', "click\n= succeed '.', ->\n  %a{:href=>'thing'} here")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['succeed'] = function(context) {
    return (function() {
      var $c, $e, $o, succeed;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      succeed = (function(_this) {
        return function(start, end, fn) {
          return window.HAML.succeed.call(_this, start, end, fn);
        };
      })(this);
      $o = [];
      $o.push("click");
      $o.push("" + $e($c(succeed('.', function() {
        var $o1;
        $o1 = [];
        $o1.push("<a href='thing'>here</a>");
        return $o1.join("\\n");
      }))));
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'uses a configured succeed function' do
        HamlCoffeeAssets.config.customSucceed = 'SomeWhere.succeed'
        expect(HamlCoffeeAssets::Compiler.compile('succeed', "click\n= succeed '.', ->\n  %a{:href=>'thing'} here")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['succeed'] = function(context) {
    return (function() {
      var $c, $e, $o, succeed;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      succeed = (function(_this) {
        return function(start, end, fn) {
          return SomeWhere.succeed.call(_this, start, end, fn);
        };
      })(this);
      $o = [];
      $o.push("click");
      $o.push("" + $e($c(succeed('.', function() {
        var $o1;
        $o1 = [];
        $o1.push("<a href='thing'>here</a>");
        return $o1.join("\\n");
      }))));
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '');
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'precede function configuration' do
      it 'uses the default precede function when no custom function is provided' do
        expect(HamlCoffeeAssets::Compiler.compile('precede', "= precede '*', ->\n  %span.small Not really")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['precede'] = function(context) {
    return (function() {
      var $c, $e, $o, precede;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      precede = (function(_this) {
        return function(start, end, fn) {
          return window.HAML.precede.call(_this, start, end, fn);
        };
      })(this);
      $o = [];
      $o.push("" + $e($c(precede('*', function() {
        var $o1;
        $o1 = [];
        $o1.push("<span class='small'>Not really</span>");
        return $o1.join("\\n");
      }))));
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '').replace(/\\s(?:id|class)=(['"])(\\1)/mg, "");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'uses a configured precede function' do
        HamlCoffeeAssets.config.customPrecede = 'SomeWhere.precede'
        expect(HamlCoffeeAssets::Compiler.compile('precede', "= precede '*', ->\n  %span.small Not really")).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['precede'] = function(context) {
    return (function() {
      var $c, $e, $o, precede;
      $e = window.HAML.escape;
      $c = window.HAML.cleanValue;
      precede = (function(_this) {
        return function(start, end, fn) {
          return SomeWhere.precede.call(_this, start, end, fn);
        };
      })(this);
      $o = [];
      $o.push("" + $e($c(precede('*', function() {
        var $o1;
        $o1 = [];
        $o1.push("<span class='small'>Not really</span>");
        return $o1.join("\\n");
      }))));
      return $o.join("\\n").replace(/\\s([\\w-]+)='true'/mg, ' $1').replace(/\\s([\\w-]+)='false'/mg, '').replace(/\\s(?:id|class)=(['"])(\\1)/mg, "");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    context 'reference function configuration' do
      it 'uses the default reference function when no custom function is provided' do
        expect(HamlCoffeeAssets::Compiler.compile('reference', '%div[@user]')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['reference'] = function(context) {
    return (function() {
      var $o, $r;
      $r = window.HAML.reference;
      $o = [];
      $o.push("<div " + ($r(this.user)) + "></div>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'uses a configured reference function' do
        HamlCoffeeAssets.config.customReference = 'SomeWhere.reference'
        expect(HamlCoffeeAssets::Compiler.compile('reference', '%div[@user]')).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['reference'] = function(context) {
    return (function() {
      var $o, $r;
      $r = SomeWhere.reference;
      $o = [];
      $o.push("<div " + ($r(this.user)) + "></div>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end
    end

    describe 'the template creation function' do
      it 'returns the JavaScript template when true' do
        expect(HamlCoffeeAssets::Compiler.compile('func', '%p', true)).to eql <<-TEMPLATE
(function() {
  if (window.JST == null) {
    window.JST = {};
  }

  window.JST['func'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<p></p>");
      return $o.join("\\n");
    }).call(window.HAML.context(context));
  };

}).call(this);
        TEMPLATE
      end

      it 'returns only the template function when false' do
        expect(HamlCoffeeAssets::Compiler.compile('func', '%p', false)).to eql <<-TEMPLATE
(function(context) {
  return (function() {
    var $o;
    $o = [];
    $o.push("<p></p>");
    return $o.join("\\n");
  }).call(window.HAML.context(context));
});
        TEMPLATE
      end
    end

  end
end
