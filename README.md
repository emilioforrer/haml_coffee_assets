# Haml Coffee Assets [![Build Status](https://secure.travis-ci.org/netzpirat/haml_coffee_assets.png)](http://travis-ci.org/netzpirat/haml_coffee_assets)

Haml Coffee Assets compiles [Haml CoffeeScript](https://github.com/netzpirat/haml-coffee) templates in the Rails 3.1
asset pipeline, so you can use them as JavaScript templates in your JavaScript heavy Rails application.

Tested on MRI Ruby 1.8.7, 1.9.2, 1.9.3, REE and the latest version of JRuby.

**Please note that I'm using haml-coffee from my fork until
[my pull request](https://github.com/9elements/haml-coffee/pull/7) is merged.**

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

### JavaScript runtimes

Haml Coffee Assets uses [ExecJS](https://github.com/sstephenson/execjs) to pick the best runtime to evaluate the
CoffeeScript and generate the JavaScript template.

* With CRuby you want to use a V8 JavaScript Engine or Mozilla SpiderMonkey.
* With JRuby you want to use the Mozilla Rhino.
* On Mac OS X you want to use Apple JavaScriptCore.
* On Linux or as a node.js developer you want to use Node.js (V8).
* On Windows you want to use Microsoft Windows Script Host.

The following sections gives you a short overview of the available JavaScript runtimes and how to install it.

### Node.js (V8)

You can install [node.js](http://nodejs.org/) and use its V8 engine. On OS X you may want to install it with
[Homebrew](http://mxcl.github.com/homebrew/), on Linux with your package manager and on Windows you have to download and
install the [executable](http://www.nodejs.org/#download).

### V8 JavaScript Engine

To use the [V8 JavaScript Engine](http://code.google.com/p/v8/), simple add `therubyracer` to your `Gemfile`.
The Ruby Racer acts as a bridge between Ruby and the V8 engine, that will be automatically installed by the Ruby Racer.

```ruby
group :development do
  gem 'therubyracer'
end
```

Another alternative is [Mustang](https://github.com/nu7hatch/mustang), a Ruby proxy library for the awesome Google V8
JavaScript engine. Just add `mustang` to your `Gemfile`:

```ruby
group :development do
  gem 'mustang'
end
```

### Mozilla SpiderMonkey

To use [Mozilla SpiderMonkey](https://developer.mozilla.org/en/SpiderMonkey), simple add `johnson` to your `Gemfile`.
Johnson embeds the Mozilla SpiderMonkey JavaScript runtime as a C extension.

```ruby
group :development do
  gem 'johnson'
end
```

### Mozilla Rhino

If you're using JRuby, you can embed the [Mozilla Rhino](http://www.mozilla.org/rhino/) runtime by adding `therubyrhino`
to your `Gemfile`:

```ruby
group :development do
  gem 'therubyrhino'
end
```

### Apple JavaScriptCore

[JavaScriptCore](http://developer.apple.com/library/mac/#documentation/Carbon/Reference/WebKit_JavaScriptCore_Ref/index.html)
is Safari's Nitro JavaScript Engine and only usable on Mac OS X. You don't have to install anything, because
JavaScriptCore is already packaged with Mac OS X.

### Microsoft Windows Script Host

[Microsoft Windows Script Host](http://msdn.microsoft.com/en-us/library/9bbdkx3k.aspx) is available on any Microsoft
Windows operating systems.

## Usage

You should place all your Haml Coffee templates in the `app/assets/templates` directory and include all templates from
your `app/assets/javascripts/application.js.coffee`:

```coffeescript
#= require_tree ../templates
```

Now you can start to add your Haml Coffee templates to your template directory. Make sure all your templates have a
`.hamlc` extension to be recognized by Haml Coffee Assets.

**Note:** Haml Coffee already generates a JavaScript Template, so there is not need to pass it to the `JST` Sprocket
processor by using `.jst.hamlc` as extension, and if you do, the Haml Coffee templates will not work.

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

By default all Haml Coffee templates are registered under the `JST` namespace.

**Example:**

A template `app/assets/templates/header.hamlc` with the given content:

```haml
%header
  %h2= title
```

will be accessible in your browser as `JST['header']`. You can now render the precompiled template and pass the data
to be rendered:

```javascript
JST['header'].render({ title: 'Hello Haml Coffee' })
```

If you prefer another namespace, you can set it in your `config/application.rb`:

```ruby
config.hamlcoffee.namespace = 'window.HAML'
```

#### Template name

The name under which the template can be addressed in the namespace depends not only from the filename, but also on
the directory name.

The following examples assumes a configured namespace `window.JST` and the asset template directory
`app/assets/templates`:

* `app/assets/templates/login.hamlc` will become `JST['login']`
* `app/assets/templates/users/new.hamlc` will become `JST['users/new']`
* `app/assets/templates/shared/form/address.hamlc` will become `JST['shared/form/address']`

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

#### Custom escape function

By default your code block in your Haml Coffee template will be escaped through the `HAML.escape` function that is
provided in the `hamlcoffee.js` script.

You can set another escaping function in your `config/application.rb`:

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
    .replace(/"/g, '&quot;')
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
