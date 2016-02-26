# Changelog

Please have a look at the [Haml Coffee Changelog](https://github.com/netzpirat/haml-coffee/blob/master/CHANGELOG.md) also.

## Master

- Update to Haml-Coffee 1.13.6

## 1.16.2 - February 25, 2016

- Fixing compatibility with older versions of rails.
- [#146][]: Incompatibility with Rails 4.2.5.1 from a change to find_templates

## 1.16.1 - January 30, 2016

- Change Gem dependencies.
- [#146][]: Incompatibility with Rails 4.2.5.1 from a change to find_templates

## 1.16.0 - December 3, 2013

- [#118][]: Change Gem dependencies.

## 1.15.1 - November 27, 2013

- Update to Haml-Coffee 1.13.5

## 1.15.0 - October 22, 2013

- Support Rails 4. ([@thedeeno][])
- Update to Haml-Coffee 1.13.3

## 1.14.1 - October 2, 2013

- [#114][]: Make `findAndPreserve` helper compatible with IE8.

## 1.14.0 - September 22, 2013

- Update to Haml-Coffee 1.12.0

## 1.13.2 - August 12, 2013

- [#109][]: Make helpers API not dependant on Rails.

## 1.13.1 - August 9, 2013

- [#108][]: Re-add helper path API to make it easy to integrate into Sinatra.

## 1.13.0 - August 6, 2013

- Update to Haml-Coffee 1.11.3
- [#104][]: Add support for Rails 4 ([@magnusvk][])
- [#102][]: Add support for Rails 2.3. ([@vlmonk][])
- [#95][]: Remove deprecated `shared_templates_api`. ([@thedeeno][])
- `findAndPreserve` helper deletes all line feed (LF) characters.
- [#87][]: Add global context server mixin feature. ([@thedeeno][])

## 1.12.0 - April 8, 2013

- Drop Ruby 1.8.7 support.
- Upgrade to Haml-Coffee 1.11.0

## 1.11.1 - January 27, 2013

- [#81][]: Disable server side templates when using AMD placement.

## 1.11.0 - January 20, 2013

- [#80][]: Add custom resolver to prevent Rails from rendering Haml Coffee templates for non-HTML formats. ([@jimmycuadra][])

## 1.10.0 - January 13, 2013

- The default name filter removes a leading underscore `_` from the template name.
- [#79][]: Add ActionView::Template handler for hamlc files. ([@jimmycuadra][])

## 1.9.1 - January 8, 2013

- Upgrade to Haml Coffee 1.9.0

## 1.8.2 - November 29, 2012

- Upgrade to Haml Coffee 1.8.2
- [#78][]: Fix nested parenthesis detection within attributes.

## 1.7.2 - November 7, 2012

- [#76][]: Fix scope extension for Sprocket JST processor template generation. ([@dhiemstra][])

## 1.7.1 - November 2, 2012

- Fix context merge when using AMD.

## 1.7.0 - November 2, 2012

- Upgrade to Haml Coffee 1.7.0
- Add `dependencies` option.
- Add AMD module version of the Haml Coffee Assets shared helpers.

## 1.6.2 - October 27, 2012

- Upgrade to Haml Coffee 1.6.2

## 1.6.0 - October 16, 2012

- Add `placement` option.
- Upgrade to Haml Coffee 1.6.0

## 1.5.1 - September 24, 2012

- Upgrade to Haml Coffee 1.5.1

## 1.4.9 - September 14, 2012

- [#69][]: Timing issue during configuration
- Upgrade to Haml Coffee 1.4.9
- Trim whitespace in the helpers and make them run in the template context.

## 1.4.7 - September 3, 2012

- [#68][]: Don't use trim() for IE <= 8 compatibility.
- Upgrade to Haml Coffee 1.4.7

## 1.4.6 - August 28, 2012

- Upgrade to Haml Coffee 1.4.6

## 1.4.5 - August 28, 2012

- Upgrade to Haml Coffee 1.4.5

## 1.4.3 - August 20, 2012

- [#65][]: CoffeScript interpolation does not work.
- Upgrade to Haml Coffee 1.4.2

## 1.4.2 - August 10, 2012

- [#63][]: Allow CoffeeScript path to be set with COFFEESCRIPT_SOURCE_PATH ([@paulyoung][])

## 1.4.1 - August 9, 2012

- [#60][]: Remove included CoffeeScript library and use the one in the gem instead ([@paulyoung][])

## 1.4.0 - August 5, 2012

- Add `HamlCoffeeAssets.helpers` to get the helper functions as CoffeeScript or compiled JavaScript.
- Upgrade to Haml Coffee 1.4.1

## 1.3.0 - August 3, 2012

- Upgrade to Haml Coffee 1.3.0

## 1.2.0 - Juli 18, 2012

- Use `&[#39][];` instead of `&apos;` for supporting IE < 9
- Upgrade to Haml Coffee 1.2.0

## 1.1.3 - Juli 4, 2012

- Upgrade to Haml Coffee 1.1.3

## 1.1.2 - June 29, 2012

- Upgrade to Haml Coffee 1.1.2

## 1.1.1 - June 19, 2012

- Upgrade to Haml Coffee 1.1.1
- [#51][]: Parsing fails with double quotes inside single-quoted attribute value.
- [#49][]: Failing to quote object literal keys.

## 1.1.0 - June 12, 2012

- Upgrade to Haml Coffee 1.1.0
- Change clean helper function to have proper render time boolean attribute conversion.

## 1.0.0 - June 10, 2012

- Upgrade to Haml Coffee 1.0.1
- Add extend scope template option.

## 0.9.5 - June 8, 2012

- Upgrade to Haml Coffee 0.8.3

## 0.9.4 - June 1, 2012

- Upgrade to Haml Coffee 0.8.2

## 0.9.3 - Mai 22, 2012

- Upgrade to Haml Coffee 0.8.1
- [#46][]: Attribute parsing partially broken.

## 0.9.2 - Mai 21, 2012

- Upgrade to Haml Coffee 0.8.0
- Internal refactoring and more specs added.

## 0.9.1 - Mai 14, 2012

- Upgrade to Haml Coffee 0.7.1

## 0.9.0 - Mai 9, 2012

- Upgrade to Haml Coffee 0.7.0

## 0.8.6 - April 30, 2012

- [#40][]: Fix special class interpolation.

## 0.8.5 - April 16, 2012

- [#38][]: Fix `customSurround` option. ([@dzello][])

## 0.8.4 - March 1, 2012

- Upgrade to Haml Coffee 0.6.2
- Fix provided precede, succeed and surround helpers.
- [#31][]: Explicit require Sprockets engine.

## 0.8.3 - February 13, 2012

- [#29][]: Fix HAML.extend for Mootools.

## 0.8.2 - February 13, 2012

- Upgrade to Haml Coffee 0.6.1

## 0.8.1 - February 13, 2012

- [#26][]: Fix HAML configuration in the JS helpers.

## 0.8.0 - January 31, 2012

- [#14][]: Make it possible to put templates in a different directory ([@jingoro][])

## 0.7.1 - January 27, 2012

- [#23][]: Fix CoffeeScript => operator ([@whitequark][])

## 0.7.0 - January 24, 2012

- Upgrade to Haml Coffee 0.6.0
- Allow processing of `.jst.hamlc.*` files as JST ([@jfirebaugh][])

## 0.6.1 - January 16, 2012

- Upgrade to Haml Coffee 0.5.6
- [#2][]: Add link to I18n.js library in the README

## 0.6.0 - January 4, 2012

- Add text param to `findAndPreserve` in ERB template ([@dzello][])
- Make haml_coffee_assets work with non-Rails projects ([@jayzes][])

## 0.5.3 - December 16, 2011

- Upgrade to Haml Coffee 0.5.5
- Add `basename` configuration

## 0.5.2 - December 16, 2011

- Upgrade to Haml Coffee 0.5.4

## 0.5.1 - December 15, 2011

- Upgrade to Haml Coffee 0.5.3

## 0.5.0 - December 13, 2011

- Upgrade to Haml Coffee 0.5.2
- [#4][]: Support for the Sprockets JST processor

## 0.4.1 - December 13, 2011

- Fix Railtie initialization when `initialize_on_precompile` is false  ([@axs89][])

## 0.4.0 - December 8, 2011

- Upgrade to Haml Coffee 0.4.0
- Add configuration of the Haml Coffee compiler settings
- add configuration of the Haml Coffee helper functions
- [#12][]: Fix wrong README examples

## 0.3.0 - November 28, 2011

- Upgrade to Haml Coffee 0.3.1
- [#9][]: null values show up as text

## 0.2.6 - November 23, 2011

- Fix [#8][]: Empty "name" attribute

## 0.2.5 - November 21, 2011

- Switch to official Haml Coffee release
- [#6][]: Doesn't work under windows (using cscript)
- [#5][]: data-inline="true" is not correctly translate

## 0.2.4 - November 16, 2011

- More strict quoting and `:` prefix checks

## 0.2.3 - November 16, 2011

- [#3][]: Tag attributes value must be "string forced"
- [#2][]: Empty lines aren't supported
- Allow `[]` in attribute code

## 0.2.2 - November 16, 2011

- hamlcoffee.js not being found ([#1][])

## 0.2.1 - November 15, 2011

- Allow `!=`, `~`, `&=` also in element assignments

## 0.2.0 - November 15, 2011

- Allow slash in template name
- Support data attributes

## 0.0.1 - November 7, 2011

- First release with my Haml Coffee fork

<!--- The following link definition list is generated by PimpMyChangelog --->
[#1]: https://github.com/netzpirat/haml_coffee_assets/issues/1
[#2]: https://github.com/netzpirat/haml_coffee_assets/issues/2
[#3]: https://github.com/netzpirat/haml_coffee_assets/issues/3
[#4]: https://github.com/netzpirat/haml_coffee_assets/issues/4
[#5]: https://github.com/netzpirat/haml_coffee_assets/issues/5
[#6]: https://github.com/netzpirat/haml_coffee_assets/issues/6
[#8]: https://github.com/netzpirat/haml_coffee_assets/issues/8
[#9]: https://github.com/netzpirat/haml_coffee_assets/issues/9
[#12]: https://github.com/netzpirat/haml_coffee_assets/issues/12
[#14]: https://github.com/netzpirat/haml_coffee_assets/issues/14
[#23]: https://github.com/netzpirat/haml_coffee_assets/issues/23
[#26]: https://github.com/netzpirat/haml_coffee_assets/issues/26
[#29]: https://github.com/netzpirat/haml_coffee_assets/issues/29
[#31]: https://github.com/netzpirat/haml_coffee_assets/issues/31
[#38]: https://github.com/netzpirat/haml_coffee_assets/issues/38
[#39]: https://github.com/netzpirat/haml_coffee_assets/issues/39
[#40]: https://github.com/netzpirat/haml_coffee_assets/issues/40
[#46]: https://github.com/netzpirat/haml_coffee_assets/issues/46
[#49]: https://github.com/netzpirat/haml_coffee_assets/issues/49
[#51]: https://github.com/netzpirat/haml_coffee_assets/issues/51
[#60]: https://github.com/netzpirat/haml_coffee_assets/issues/60
[#63]: https://github.com/netzpirat/haml_coffee_assets/issues/63
[#65]: https://github.com/netzpirat/haml_coffee_assets/issues/65
[#68]: https://github.com/netzpirat/haml_coffee_assets/issues/68
[#69]: https://github.com/netzpirat/haml_coffee_assets/issues/69
[#76]: https://github.com/netzpirat/haml_coffee_assets/issues/76
[#78]: https://github.com/netzpirat/haml_coffee_assets/issues/78
[#79]: https://github.com/netzpirat/haml_coffee_assets/issues/79
[#80]: https://github.com/netzpirat/haml_coffee_assets/issues/80
[#81]: https://github.com/netzpirat/haml_coffee_assets/issues/81
[#87]: https://github.com/netzpirat/haml_coffee_assets/issues/87
[#95]: https://github.com/netzpirat/haml_coffee_assets/issues/95
[#102]: https://github.com/netzpirat/haml_coffee_assets/issues/102
[#104]: https://github.com/netzpirat/haml_coffee_assets/issues/104
[#108]: https://github.com/netzpirat/haml_coffee_assets/issues/108
[#118]: https://github.com/netzpirat/haml_coffee_assets/issues/118
[@axs89]: https://github.com/axs89
[@dhiemstra]: https://github.com/dhiemstra
[@dzello]: https://github.com/dzello
[@jayzes]: https://github.com/jayzes
[@jfirebaugh]: https://github.com/jfirebaugh
[@jimmycuadra]: https://github.com/jimmycuadra
[@jingoro]: https://github.com/jingoro
[@magnusvk]: https://github.com/magnusvk
[@paulyoung]: https://github.com/paulyoung
[@thedeeno]: https://github.com/thedeeno
[@vlmonk]: https://github.com/vlmonk
[@whitequark]: https://github.com/whitequark
