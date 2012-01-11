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

## Usage

You should place all your Haml Coffee templates in the `app/assets/templates` directory and include all templates from
your `app/assets/javascripts/application.js.coffee`:

```coffeescript
#= require_tree ../templates
```
Now you can start to add your Haml Coffee templates to your template directory.

### Sprocket JST processor template generation

* Extension: `.jst.hamlc`

When you give your templates the extension `.jst.hamlc`, Haml Coffee Assets will only generate the template function,
which then in turn will be further processed by the
[Sprocket JST processor](https://github.com/sstephenson/sprockets/blob/master/lib/sprockets/jst_processor.rb).
This is the Rails way of asset processing and the only downside is that namespace definition is more cumbersome.

### Haml Coffee template generation

* Extension: `.hamlc`

If you omit the `.jst` and give your templates only a `.hamlc` extension, then Haml Coffee Assets will handle the
JavaScript template generation. With this approach you can easily define your own namespace with a simple configuration.

## Configuration

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
`app/assets/templates/header.hamlc` with the given content:

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

#### Template name

The name under which the template can be addressed in the namespace depends not only from the filename, but also on
the directory name by default.

The following examples assumes a configured namespace `window.JST` and the asset template directory
`app/assets/templates`:

* `app/assets/templates/login.hamlc` will become `JST['login']`
* `app/assets/templates/users/new.hamlc` will become `JST['users/new']`
* `app/assets/templates/shared/form/address.hamlc` will become `JST['shared/form/address']`

### Basename

If you don't want to have your directory names under which your template is located to be contained in the JST name,
you can configure Haml Coffee n your `config/application.rb` to strip off the path to the file name and only use the
basename as JST name:

```ruby
config.hamlcoffee.basename = true
```

With this setting enabled the following naming rule applies:

* `app/assets/templates/login.hamlc` will become `JST['login']`
* `app/assets/templates/users/new.hamlc` will become `JST['new']`
* `app/assets/templates/shared/form/address.hamlc` will become `JST['address']`

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
each template.

There is a example implementation provided in the `hamlcoffee.js` that can use the `extend` like functions
from the listed frameworks to merge the global and the local conext data:

* jQuery
* Underscore.js
* Prototype
* MooTools
* Zepto.js

If you use one of these, than you can simply override `HAML.globals` and return the global context data:

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
The following example uses the _.underscore `extend` function to merge the global context data with the
passed local context data:

```coffeescript
App.globalTemplateContext = (locals) -> _.extend({}, {
    authenticated: App.isAuthenticated()
}, locals)
```

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
to, you can.

#### Custom escape function

By default your code block in your Haml Coffee template will be escaped through the `HAML.escape` function that is
provided in the `hamlcoffee.js` script.

You can set a custom escaping function in your `config/application.rb`:

```ruby
config.hamlcoffee.customHtmlEscape = 'App.myEscape'
```

Your custom escape function must take the unescaped text as parameter and returns the escaped text.
The following default implementation comes with `hamlcoffee.js`:

```coffeescript
App.myEscape = (text) ->
  ('' + text)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/'/g, '&apos;')
    .replace(/"/g, '&quot;')
```

#### Custom clean value function

All your evaluated CoffeeScript code will go through the clean value function. By default this simply cleans `undefined`
and `null` values, so that they appear as empty string in your template.

You can set a custom clean value function in your `config/application.rb`:

```ruby
config.hamlcoffee.customCleanValue = 'App.myCleanValue'
```

Your custom clean value function must take the value as parameter and returns the cleaned value.
The following default implementation comes with `hamlcoffee.js`:

```coffeescript
App.myCleanValue = (value) -> if value is null or value is undefined then '' else value
```

#### Custom preserve function

All the content from the HTML tags that are contained in the whitespace sensitive tag list are passed through the
preserve function.

You can set a custom preserve function in your `config/application.rb`:

```ruby
config.hamlcoffee.customPreserve = 'App.myPreserve'
```

Your custom preserve function must take the text to be preserved as parameter and returns the preserved content.
The following default implementation comes with `hamlcoffee.js`:

```coffeescript
App.myPreserve = (value) -> text.replace /\\n/g, '&#x000A;'
```

#### Custom find and preserve function

The findAndPreserve function is a specialized preserve function, that you can pass a text containing HTML, and only the
newlines in between a whitespace sensitive tag are preserved. This function uses the previous preserve function to do
the final preservation.

You can set a custom find and preserve function in your `config/application.rb`:

```ruby
config.hamlcoffee.customFindAndPreserve = 'App.myFindAndPreserve'
```

Your custom find and preserve function must take the text to search for whitespace sensitive tags as parameter and
returns the preserved content.

The following default implementation comes with `hamlcoffee.js`:

```coffeescript
App.myPreserve = (value) ->
  text.replace /<(textarea|pre)>([^]*?)<\/\1>/g, (str, tag, content) ->
    "<#{ tag }>#{ HAML.preserve(content) }</#{ tag }>"
```

## Development

* Issues and feature request hosted at [GitHub Issues](https://github.com/netzpirat/haml_coffee_assets/issues).
* Documentation hosted at [RubyDoc](http://rubydoc.info/github/netzpirat/haml_coffee_assets/master/frames).
* Source hosted at [GitHub](https://github.com/netzpirat/haml_coffee_assets).

Pull requests are very welcome! Please try to follow these simple rules if applicable:

* Please create a topic branch for every separate change you make.
* Make sure your patches are well tested. All specs must pass.
* Update the [Yard](http://yardoc.org/) documentation.
* Update the README.
* Please **do not change** the version number.

For questions please join `#haml` on irc.freenode.net

## Contributors

* [Arun Sivashankaran](https://github.com/axs89)
* [Jay Zeschin](https://github.com/jayzes)

## Acknowledgement

* [Jeremy Ashkenas](http://twitter.com/#!/jashkenas) for CoffeeScript, that little language that compiles into
  JavaScript.
* The people at [9elements](https://github.com/9elements) who gave us
  [haml-coffee](https://github.com/9elements/haml-coffee), an elegant JavaScript template solution.

## License

(The MIT License)

Copyright (c) 2011 Michael Kessler

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
