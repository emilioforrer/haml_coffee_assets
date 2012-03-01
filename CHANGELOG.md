# Changelog

Please also have a look at the [Haml Coffee Changelog](https://github.com/9elements/haml-coffee/blob/master/CHANGELOG.md).

## 0.8.4 - March 1, 2012

- Upgrade to Haml Coffee 0.6.2
- Fix provided precede, succeed and surround helpers.
- [Pull #31](https://github.com/netzpirat/haml_coffee_assets/pull/31): Explicit require Sprockets engine.

## 0.8.3 - February 13, 2012

- [Pull #29](https://github.com/netzpirat/haml_coffee_assets/pull/29): Fix HAML.extend for Mootools.

## 0.8.2 - February 13, 2012

- Upgrade to Haml Coffee 0.6.1

## 0.8.1 - February 13, 2012

- [Pull #26](https://github.com/netzpirat/haml_coffee_assets/pull/26): Fix HAML configuration in the JS helpers.

## 0.8.0 - January 31, 2012

- [Issue #14](https://github.com/netzpirat/haml_coffee_assets/issues/14): Make it possible to put templates in a different directory ([@jingoro][])

## 0.7.1 - January 27, 2012

- [Issue #23](https://github.com/netzpirat/haml_coffee_assets/issues/23): Fix CoffeeScript => operator ([@whitequark][])

## 0.7.0 - January 24, 2012

- Upgrade to Haml Coffee 0.6.0
- Allow processing of `.jst.hamlc.*` files as JST ([@jfirebaugh][])

## 0.6.1 - January 16, 2012

- Upgrade to Haml Coffee 0.5.6
- [Issue #21](https://github.com/netzpirat/haml_coffee_assets/issues/21): Add link to I18n.js library in the README

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
- [Issue #4](https://github.com/netzpirat/haml_coffee_assets/issues/4): Support for the Sprockets JST processor

## 0.4.1 - December 13, 2011

- Fix Railtie initialization when `initialize_on_precompile` is false  ([@axs89][])

## 0.4.0 - December 8, 2011

- Upgrade to Haml Coffee 0.4.0
- Add configuration of the Haml Coffee compiler settings
- add configuration of the Haml Coffee helper functions
- [Issue #12](https://github.com/netzpirat/haml_coffee_assets/issues/12): Fix wrong README examples

## 0.3.0 - November 28, 2011

- Upgrade to Haml Coffee 0.3.1
- [Issue #9](https://github.com/netzpirat/haml_coffee_assets/issues/9): null values show up as text

## 0.2.6 - November 23, 2011

- Fix [Issue #8](https://github.com/netzpirat/haml_coffee_assets/issues/8): Empty "name" attribute

## 0.2.5 - November 21, 2011

- Switch to official Haml Coffee release
- [Issue #6](https://github.com/netzpirat/haml_coffee_assets/issues/6): Doesn't work under windows (using cscript)
- [Issue #5](https://github.com/netzpirat/haml_coffee_assets/issues/5): data-inline="true" is not correctly translate

## 0.2.4 - November 16, 2011

- More strict quoting and `:` prefix checks

## 0.2.3 - November 16, 2011

- [Issue #3](https://github.com/netzpirat/haml_coffee_assets/issues/3): Tag attributes value must be "string forced"
- [Issue #2](https://github.com/netzpirat/haml_coffee_assets/issues/2): Empty lines aren't supported
- Allow `[]` in attribute code

## 0.2.2 - November 16, 2011

- [Issue #1](https://github.com/netzpirat/haml_coffee_assets/issues/1): hamlcoffee.js not being found

## 0.2.1 - November 15, 2011

- Allow `!=`, `~`, `&=` also in element assignments

## 0.2.0 - November 15, 2011

- Allow slash in template name
- Support data attributes

## 0.0.1 - November 7, 2011

- First release with my Haml Coffee fork

[@axs89]: https://github.com/axs89
[@dzello]: https://github.com/dzello
[@jfirebaugh]: https://github.com/jfirebaugh
[@jingoro]: https://github.com/jingoro
[@jayzes]: https://github.com/jayzes
[@whitequark]: https://github.com/whitequark
