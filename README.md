# Haml Coffee Assets [![Build Status](https://secure.travis-ci.org/netzpirat/haml_coffee_assets.png)](http://travis-ci.org/netzpirat/haml_coffee_assets)

Haml Coffee Assets compiles [Haml Coffee](https://github.com/9elements/haml-coffee) templates in the Rails 3.1
asset pipeline, so you can use them as JavaScript templates in your JavaScript heavy Rails application. It also works as [Tilt](https://github.com/rtomayko/tilt/) template without Rails.

Tested on MRI Ruby 1.8.7, 1.9.2, 1.9.3, REE and the latest version of JRuby.

## Haml Coffee

Haml Coffee allows you to write inline [CoffeeScript](http://jashkenas.github.com/coffee-script/) in your
[HAML](http://haml-lang.com/) JavaScript templates:

```haml
#cart
  %h2= I18n.t('js.cart.title')
  - if @cart.length == 0
    %p.empty= I18n.t('js.cart.empty')
  - else
    %ul
      - for item in @cart
        %li
          .item
            = item.name
            %a{ :href => "/cart/item/remove/#{ item.id }" }
              = I18n.t('js.cart.item.remove')
```

Please note that the `I18n` object in the above example is not part ot Haml Coffee Assets, the internationalization
functions are provided by the [i18n.js](https://github.com/fnando/i18n-js) library.

## Installation

The simplest way to install Haml Coffee Assets is to use [Bundler](http://gembundler.com/).
Add `haml_coffee_assets` and `execjs` to your `Gemfile`:

```ruby
group :assets do
  gem 'haml_coffee_assets'
  gem 'execjs'
end
```

And require the `hamlcoffee.js` in your `app/assets/javascripts/application.js.coffee`:

```coffeescript
#= require hamlcoffee
```

This provides the default escaping and the global context functions. Read more about it in the configuration section
below.

Please have a look at the [CHANGELOG](https://github.com/netzpirat/haml_coffee_assets/blob/master/CHANGELOG.md) when
upgrading to a newer Haml Coffee Assets version.

## Usage

Haml Coffee Assets allows two different ways of generating your JavaScript templates:

### Sprocket JST processor template generation

* Extension: `.jst.hamlc`

When you give your templates the extension `.jst.hamlc`, Haml Coffee Assets will only generate the template function,
which then in turn will be further processed by the
[Sprocket JST processor](https://github.com/sstephenson/sprockets/blob/master/lib/sprockets/jst_processor.rb). Because
Haml Coffee Assets will not generate the template, you can't use the template name filter and the JST namespace
definition is more cumbersome compared to the Haml Coffee template generation.

With this approach you should place all your Haml Coffee templates in the `app/assets/templates` directory and include
all templates from your `app/assets/javascripts/application.js.coffee`:

```coffeescript
#= require_tree ../templates
```

If you would place your templates into `app/assets/javascripts/templates`, then all your JST template names would begin
with `templates/`, which may be not what you want.

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
if you just use the Tilt template you can access the configuration with `HamlCoffeeAssets.config`. All the following
examples use the Rails way.

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

By default, `name_filter` strips the leading `templates/` directory off of the name. Please note, `name_filter` is only
applicable if you use the `.hamlc` extension and let Haml Coffee Assets handle the JST generation. If you use the
`.jst.hamlc` extension, then Sprockets JST processor will name things accordingly (e.g., with `templates/` intact in
this case).

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
  %h1= I18n.t('js.app.notfound.error', { route: @route })
  - if @isAuthenticated
    %p= I18n.t('js.app.notfound.homepage')
  - else
    %p= I18n.t('js.app.notfound.login')
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

Please have a look at the wiki for [further examples](https://github.com/netzpirat/haml_coffee_assets/wiki) on how to
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
config.hamlcoffee.preserve = 'pre,textarea,abbr'
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

You can see the [default implementation](https://github.com/netzpirat/haml_coffee_assets/blob/master/vendor/assets/javascripts/hamlcoffee.js.coffee.erb)
and the [Haml Coffee documentation](https://github.com/9elements/haml-coffee#custom-helper-function-compiler-options)
for more information about each helper function.

## Author

Developed by Michael Kessler, [mksoft.ch](https://mksoft.ch).

If you like Haml Coffee Assets, you can watch the repository at [GitHub](https://github.com/netzpirat/haml_coffee_assets) and
follow [@netzpirat](https://twitter.com/#!/netzpirat) on Twitter for project updates.

## Development

* Issues and feature request hosted at [GitHub Issues](https://github.com/netzpirat/haml_coffee_assets/issues).
* Documentation hosted at [RubyDoc](http://rubydoc.info/github/netzpirat/haml_coffee_assets/master/frames).
* Source hosted at [GitHub](https://github.com/netzpirat/haml_coffee_assets).

Pull requests are very welcome! Please try to follow these simple rules if applicable:

* Please create a topic branch for every separate change you make.
* Make sure your patches are well tested. All specs must pass.
* Update the [Yard](http://yardoc.org/) documentation.
* Update the README.
* Update the CHANGELOG for noteworthy changes.
* Please **do not change** the version number.

For questions please join `#haml` on irc.freenode.net

## Contributors

See the [CHANGELOG](https://github.com/netzpirat/haml_coffee_assets/blob/master/CHANGELOG.md) and the GitHub list of
[contributors](https://github.com/netzpirat/haml_coffee_assets/contributors).

## Acknowledgement

* [Jeremy Ashkenas](http://twitter.com/#!/jashkenas) for CoffeeScript, that little language that compiles into
  JavaScript.
* The people at [9elements](https://github.com/9elements) who gave us
  [haml-coffee](https://github.com/9elements/haml-coffee), an elegant JavaScript template solution.

## License

(The MIT License)

Copyright (c) 2011-2012 Michael Kessler

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
