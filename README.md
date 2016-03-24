# Haml Coffee Assets [![Build Status](https://secure.travis-ci.org/emilioforrer/haml_coffee_assets.png)](http://travis-ci.org/emilioforrer/haml_coffee_assets)

Haml Coffee Assets compiles [Haml Coffee](https://github.com/netzpirat/haml-coffee) templates in the Rails 3.1 asset
pipeline, so you can use them as JavaScript templates in your JavaScript heavy Rails application. Server-side rendering
of templates is also possible, allowing you to share the same template files for Rails and JavaScript templates. It also
works as a pure [Sprockets](https://github.com/sstephenson/sprockets) engine without Rails.

Tested on MRI Ruby 1.9.3, 2.0.0 and the latest version of JRuby.

## Features

* Seamless integration of [Haml-Coffee](https://github.com/netzpirat/haml-coffee) into the Rails asset pipeline or as
standalone Sprockets engine.
* Manifold options to configure Haml Coffee Assets to your needs.
* AMD support.
* Server-side rendering of templates in Rails.

## Haml Coffee

Haml Coffee allows you to write inline [CoffeeScript](http://jashkenas.github.com/coffee-script/) in your
[HAML](http://haml-lang.com/) JavaScript templates:

```haml
#cart
  %h2 Cart
  - if @cart.length is 0
    %p.empty Your cart is empty
  - else
    %ul
      - for item in @cart
        %li
          .item
            = item.name
            %a{ :href => "/cart/item/remove/#{ item.id }" } Remove Item
```

You can try Haml Coffee online by visiting [Haml Coffee Online](http://haml-coffee-online.herokuapp.com/) and have a
look [the AMD example Rails app](https://github.com/netzpirat/haml_coffee_assets-amd-demo).

## Installation

The simplest way to install Haml Coffee Assets is to use [Bundler](http://gembundler.com/).
Add `haml_coffee_assets` and `execjs` to your `Gemfile`:

```ruby
group :assets do
  gem 'haml_coffee_assets'
  gem 'execjs'
end
```
(note that Rails 4.0 [removed the assets group](https://github.com/rails/rails/commit/49c4af43ec5819d8f5c1a91f9b84296c927ce6e7) from Gemfile and so you don't need that line) and require the `hamlcoffee.js` in your `app/assets/javascripts/templates/context.js.coffee`:

```coffeescript
#= require hamlcoffee
```

If you're using AMD support then you do not need to include the above helper, since it will be automatically included.

This provides the default escaping and the global context functions. Read more about it in the configuration section
below.

Please have a look at the [CHANGELOG](https://github.com/emilioforrer/haml_coffee_assets/blob/master/CHANGELOG.md) when
upgrading to a newer Haml Coffee Assets version.

If you want to use Haml Coffee with Sinatra, please have a look at the
[Haml Coffee Sinatra](https://github.com/netzpirat/haml-coffee-sinatra) demo application.

## Usage

Haml Coffee Assets allows two different ways of generating your JavaScript templates, but the Haml Coffee template
generation is preferred, since it provides more configuration options and a smoother experience.

### Haml Coffee template generation

* Extension: `.hamlc`

If you omit the `.jst` and give your templates only a `.hamlc` extension, then Haml Coffee Assets will handle the
JavaScript template generation. With this approach you can easily define your own namespace with a simple configuration
and you can use the template name filter.

You can place all your Haml Coffee templates in the `app/assets/javascripts/templates` directory and include all
templates from your `app/assets/javascripts/application.js.coffee`:

```coffeescript
#= require_tree ./templates
```

Because Haml Coffee Assets provides a default template name filter, the `templates/` prefix will be automatically
removed.

### Sprocket JST processor template generation

* Extension: `.jst.hamlc`

When you give your templates the extension `.jst.hamlc`, Haml Coffee Assets will only generate the template function,
which then in turn will be further processed by the
[Sprocket JST processor](https://github.com/sstephenson/sprockets/blob/master/lib/sprockets/jst_processor.rb). Because
Haml Coffee Assets will not generate the template, you can't use the AMD support, template name filter and the JST
namespace definition is more cumbersome compared to the Haml Coffee template generation.

With this approach you should place all your Haml Coffee templates in the `app/assets/templates` directory and include
all templates from your `app/assets/javascripts/application.js.coffee`:

```coffeescript
#= require_tree ../templates
```

If you would place your templates into `app/assets/javascripts/templates`, then all your JST template names would begin
with `templates/`, which may be not what you want.

### Server-side rendering in Rails

Haml Coffee Assets registers the `.hamlc` extension with Action View, so that Rails templates can be written in Haml
Coffee. Rails will see templates placed in `app/assets/javascripts/templates` (though this path can be changed if you
store your templates in another directory), and the same template files can be rendered via Rails or via JavaScript on
the client. Server-side rendering is only available when using the global placement and not with the AMD placement.

Given a Haml Coffee template at `app/assets/javascripts/templates/books/_book.hamlc`:

```haml
%dl
  %dt Name
  %dd= @name
  %dt Author
  %dd= @author
```

And a Haml Coffee context at `app/assets/javascripts/templates/context.js`:

```javascript
//= require hamlcoffee
```

To render on server in `books#index`:

```haml
= render "book", :name => "A Tale of Two Cities", :author => "Charles Dickens"
```

To render and render the same file on the client using the asset pipeline:

```coffeescript
#= require hamlcoffee
#= require templates/books/_book

JST["books/book"](name: "A Tale of Two Cities", author: "Charles Dickens")
```

Note that the template is required as `books/_book` because it refers to the actual file, but the template name on the
client is simply `books/book`. If you require all templates at once with `#= require_tree ./templates`, you won't need
to remember this distinction.

## Configuration

_Please note that all configuration examples will use the paths of the Haml Coffee template generation and not the
Sprocket JST processor template generation._

Sprockets will cache your templates after compiling and will only recompile them when the content of the template has
changed, thus if you change to your configuration, the new settings will not be applied to templates already compiled.
You can clear the Sprockets cache with:

```Bash
rake assets:clean
```

For Rails, you can set the configuration options in your environment by accessing `config.hamlcoffee`, whereas
if you just use the plain Sprockets engine you can access the configuration with `HamlCoffeeAssets.config`. All the
following examples use the Rails way.

**Please note:** When you put Haml Coffee Assets into the `:assets` group within your `Gemfile` and precompile the
assets (the default Rails behaviour), then Haml Coffee Assets is not loaded in production and you can't set any
configuration at `config.hamlcoffee` in both `config/application.rb` and `config/environments/production.rb`.

You can simply add a condition around the configuration:

```Ruby
if defined? ::HamlCoffeeAssets
 config.hamlcoffee.awesome = true
end
```

or move your configuration to `config/environments/development.rb` (and `config/environments/test.rb`, depending on your
JavaScript testing setup).

### Document format

By default all Haml Coffee templates are rendered to a HTML5 document. You can choose between the following output
formats:

* html5
* html4
* xhtml

If you prefer another HTML format than HTML5, you can set it in your `config/application.rb`:

```ruby
config.hamlcoffee.format = 'xhtml'
```

### Template placement

By default all Haml Coffee templates are placed under the configured template namespace. You can choose between the
following placements:

* global
* amd

By setting the placement option to `amd`, each template will be wrapped within a `define` function, enabling the usage
of a module loader.

```ruby
config.hamlcoffee.placement = 'amd'
```

Please note, the `placement` option is only applicable if you use the `.hamlc` extension and let Haml Coffee Assets
handle the JST generation. The global `hamlcoffee` helpers must be loaded normally before making use of any
templates due to the current template design.

### Global template dependencies

Haml Coffee Assets allows you to globally define the module dependencies for all templates. By default, the Haml Coffee
Assets helper is included, but you can add your own:

```ruby
config.hamlcoffee.dependencies = { '_' => 'underscore', :hc => 'hamlcoffee_amd' }
```

If you do not include the `hamlcoffee_amd` module as `hc` in the list, then the helper methods will be included in each
template, increasing its size. It's recommended to always have the `hamlcoffee` module included.

### Template namespace

By default all Haml Coffee templates are registered under the `JST` namespace. A template
`app/assets/javascripts/templates/header.hamlc` with the given content:

```haml
%header
  %h2= @title
```

will be accessible in your browser as `JST['header']`. You can now render the precompiled template and pass the data
to be rendered:

```javascript
JST['header']({ title: 'Hello Haml Coffee' })
```

If you prefer another namespace, you can set it in your `config/application.rb`:

```ruby
config.hamlcoffee.namespace = 'window.HAML'
```

You can even set a deep nested namespace like `window.templates.HAML` and Haml Coffee will handle creation all the way
down.

You can't use this configuration if you give your templates a `.jst.hamlc` extension, because the Sprockets JST
processor handles the template generation. In this case you have to subclass the JST processor:

```ruby
class MyJstProcessor < Sprockets::JstProcessor
  def prepare
    @namespace = 'MyApp.Tpl'
  end
end

Foo::Application.assets.register_engine '.jst', MyJstProcessor
```

And you must make sure `MyApp` exists before any template is loaded.

### Template name

The name under which the template can be addressed in the namespace depends not only from the filename, but also on
the directory name by default.

The following examples assumes a configured namespace `window.JST` and the asset template directory
`app/assets/javascripts/templates`:

* `app/assets/javascripts/templates/login.hamlc` will become `JST['login']`
* `app/assets/javascripts/templates/users/new.hamlc` will become `JST['users/new']`
* `app/assets/javascripts/templates/shared/form/address.hamlc` will become `JST['shared/form/address']`

#### Template name filter

If you wish to put the templates in a different location, you may want to change the `name_filter` config.

```ruby
config.hamlcoffee.name_filter = lambda { |n| n.sub /^templates\//, '' }
```

By default, `name_filter` strips the leading `templates/` directory off of the name and also a leading `_` from the
template name. Please note, `name_filter` is only applicable if you use the `.hamlc` extension and let Haml Coffee
Assets handle the JST generation. If you use the `.jst.hamlc` extension, then Sprockets JST processor will name
things accordingly (e.g., with `templates/` intact in this case).

The template name filter is not used with AMD loader.

### Basename

If you don't want to have your directory names under which your template is located to be contained in the JST name,
you can configure Haml Coffee in your `config/application.rb` to strip off the path to the file name and only use the
basename as JST name:

```ruby
config.hamlcoffee.basename = true
```

With this setting enabled the following naming rule applies:

* `app/assets/javascripts/templates/login.hamlc` will become `JST['login']`
* `app/assets/javascripts/templates/users/new.hamlc` will become `JST['new']`
* `app/assets/javascripts/templates/shared/form/address.hamlc` will become `JST['address']`

This setting has only an effect when you're using Haml Coffee to generate the JST and not when using the Sprockets
JST processor.

### Escaping

All generated output by running CoffeeScript in your template is being escaped, but you can disable escaping of either
the attributes or the generated Html.

#### Attribute escaping

You can toggle attribute escaping in your `config/application.rb`:

```ruby
config.hamlcoffee.escapeAttributes = false
```

#### HTML escaping

You can toggle HTML escaping in your `config/application.rb`:

```ruby
config.hamlcoffee.escapeHtml = false
```

#### Clean values

Every value that is returned from inline CoffeeScript will be cleaned by default. The included implementation converts
`null` and `undefined` to an empty string. You can disable value cleaning in your `config/application.rb`:

```ruby
config.hamlcoffee.cleanValue = false
```

### Uglify generated HTML

By default all generated HTML is indented to have a nice reading experience. If you like to ignore indention to have a
better rendering performance, you can enable the uglify option in your `config/application.rb`:

```ruby
config.hamlcoffee.uglify = true
```

### Global context

Haml Coffee Assets allows you to configure a global context function that gets merged into the local template context for
each template. You can simply override `HAML.globals` and return the global context data:

```coffeescript
HAML.globals = ->
  {
    isAuthenticated: App.isAuthenticated()
    isAdmin: App.currentUser.hasRole('admin')
  }
```

Now you can use the properties from the global context in every template:

```haml
.not-found-error
  %h1 Page not found
  - if @isAuthenticated
    %p Please visit the home page.
  - else
    %p Please log into your account.
```

When rendering on the server, haml_coffee_assets will expect the global context to be overriden with the `global_context_asset`. Located by default at `templates/context`.

You can configure the path to this asset in your `config/application.rb`:

```ruby
config.hamlcoffee.global_context_asset = 'templates/context'
```

If you like to use your own implementation, simply configure your context function in your `config/application.rb`:

```ruby
config.hamlcoffee.context = 'App.globalTemplateContext'
```

or disable the global context completely:

```ruby
config.hamlcoffee.context = false
```

Your custom context function must take the local context as parameter and returns the merged context data.
The following example uses the Haml Coffee Assets `extend` function to merge the global context data with the
passed local context data:

```coffeescript
App.globalTemplateContext = (locals) -> HAML.extend({}, {
    authenticated: App.isAuthenticated()
}, locals)
```

Please have a look at the wiki for [further examples](https://github.com/emilioforrer/haml_coffee_assets/wiki) on how to
use the global context.

### Customize the tag lists

Haml Coffee contains two list of HTML tags that you can customize. In general you're fine with the defaults, but if
you need to extend the list, you can instruct Haml Coffee Assets to do so.

#### Whitespace sensitive tag list

* Tags: `textarea`, `pre`

Some HTML tags are whitespace sensitive, which means that whitespace used for proper indention results in a wrong
display of the tag. In order to avoid this, the content is preserved by converting the newlines to a HTML
entity. You can set your own list of whitespace sensitive tags in your `config/application.rb`:

```ruby
config.hamlcoffee.preserveTags = 'pre,textarea,abbr'
```

This list is also taken into account for the `HAML.preserveAndFind` helper function that is provided and its shortcut
notation `~`.

#### Auto-closing tag list

Tags: `meta`, `img`, `link`, `br`, `hr`, `input`, `area`, `param`, `col`, `base`

The auto-closing tag list will contains the tags that will be self-closes if they have no content. You can set the
list of self closing tags in your `config/application.rb`:

```ruby
config.hamlcoffee.autoclose = 'meta,img,link,br,hr,input,area,param,col,base'
```

### Custom helper functions

Haml Coffee Assets provides a set of custom functions for Haml Coffee, so that the templates doesn't have to be self
contained and can make use of the global functions. In general you don't have to customize them further, but if you need
to, you can set custom functions for:

* config.hamlcoffee.customHtmlEscape
* config.hamlcoffee.customCleanValue
* config.hamlcoffee.customPreserve
* config.hamlcoffee.customFindAndPreserve
* config.hamlcoffee.customSurround
* config.hamlcoffee.customSucceed
* config.hamlcoffee.customPrecede

You can see the [default implementation](https://github.com/emilioforrer/haml_coffee_assets/blob/master/vendor/assets/javascripts/hamlcoffee.js.coffee.erb)
and the [Haml Coffee documentation](https://github.com/netzpirat/haml-coffee#custom-helper-function-options)
for more information about each helper function.

### Templates path

Rails will look for templates in `app/assets/javascripts/templates` when rendering on the server side. If you store your
 templates in another directory, you can change this location:

```ruby
config.hamlcoffee.templates_path = "custom/template/path"
```

## Partial rendering

With Haml Coffee Assets you can render partials when using plain JST approach and also with AMD support.

### JST partial rendering

With the traditional JST approach, all the templates are globally accessible in your defined namespace, which is `JST`
by default. This allows you to render a template within another template like:

```
%h1 Comments for this article
- for comment in @article.comments
  != JST['articles/comment'](comment)
```

### AMD partial rendering

Haml Coffee parses the template source code for `require` statements and adds them to the template module dependencies.
This allows you to require other templates like this:

```Haml
- require 'module'
- require 'deep/nested/other'
```

Now your dependencies are available in the template, allowing you to render it with:

```Haml
!= module()
!= other()
```

Please note that only the basename ot the template is used as module variable name.

Of course you can also directly require and render a template like:

```haml
!= require("another/other")()
```

Please have a look at [the AMD example Rails app](https://github.com/netzpirat/haml_coffee_assets-amd-demo) for a working
example.

## Author

Developed by Michael Kessler, [FlinkFinger](http://www.flinkfinger.com).

If you like Haml Coffee Assets, you can watch the repository at [GitHub](https://github.com/emilioforrer/haml_coffee_assets)
and follow [@netzpirat](https://twitter.com/#!/netzpirat) on Twitter for project updates.

## Development

* Issues and feature request hosted at [GitHub Issues](https://github.com/emilioforrer/haml_coffee_assets/issues).
* Documentation hosted at [RubyDoc](http://rubydoc.info/github/emilioforrer/haml_coffee_assets/master/frames).
* Source hosted at [GitHub](https://github.com/emilioforrer/haml_coffee_assets).

Pull requests are very welcome! Please try to follow these simple rules if applicable:

* Please create a topic branch for every separate change you make.
* Make sure your patches are well tested. All specs must pass.
* Update the [Yard](http://yardoc.org/) documentation.
* Update the README.
* Update the CHANGELOG for noteworthy changes.
* Please **do not change** the version number.

For questions please join `#haml` on irc.freenode.net

### Open Commit Bit

Guard has an open commit bit policy: Anyone with an accepted pull request gets added as a repository collaborator.
Please try to follow these simple rules:

* Commit directly onto the master branch only for typos, improvements to the readme and documentation (please add
  `[ci skip]` to the commit message).
* Create a feature branch and open a pull-request early for any new features to get feedback.
* Make sure you adhere to the general pull request rules above.

## Contributors

See the [CHANGELOG](https://github.com/emilioforrer/haml_coffee_assets/blob/master/CHANGELOG.md) and the GitHub list of
[contributors](https://github.com/emilioforrer/haml_coffee_assets/contributors).

## Acknowledgement

* [Jeremy Ashkenas](http://twitter.com/#!/jashkenas) for CoffeeScript, that little language that compiles into
  JavaScript.
* The people at [9elements](https://github.com/9elements) who started
  [haml-coffee](https://github.com/9elements/haml-coffee), an elegant JavaScript template solution.

## License

(The MIT License)

Copyright (c) 2011-2013 Michael Kessler

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
