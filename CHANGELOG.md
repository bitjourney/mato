# The revision history of Mato

## v2.2.0 - 2020/05/08

https://github.com/bitjourney/mato/compare/v2.1.4...v2.2.0

* BREAKING: Drop support for Ruby 2.3
* Display code block as plan text if Rouge raises an error [#21](https://github.com/bitjourney/mato/pull/21)


## v2.1.4 - 2019/4/11

https://github.com/bitjourney/mato/compare/v2.1.3...v2.1.4

* Fix broken mention link process in case of including unexpected text

## v2.1.3 - 2019/1/15

https://github.com/bitjourney/mato/compare/v2.1.2...v2.1.3

* Fix anchor in case of heading which is only special characters

## v2.1.2 - 2018/10/23

https://github.com/bitjourney/mato/compare/v2.1.1...v2.1.2

* Add UNSAFE to DEFAULT_MARKDOWN_RENDER_OPTIONS

## v2.1.1 - 2018/02/22

https://github.com/bitjourney/mato/compare/v2.1.0...v2.1.1

* Fix language detection in fenced code blocks [#14](https://github.com/bitjourney/mato/pull/14)

## v2.1.0 - 2018/02/21

https://github.com/bitjourney/mato/compare/v2.0.1...v2.1.0

* Enable `:TABLE_PREFER_STYLE_ATTRIBUTE` added in CommonMarker v0.17.8 [#13](https://github.com/bitjourney/mato/pull/13)

## v2.0.1 - 2017/12/14

https://github.com/bitjourney/mato/compare/v2.0.0...v2.0.1

* fix ToC renderer to make consistent HTML from inconsistent headings [#12](https://github.com/bitjourney/mato/pull/12)

## v2.0.0 - 2017/11/27

https://github.com/bitjourney/mato/compare/v1.3.1...v2.0.0

* Enable kramdown-style footnotes which is an extension in github/cmark [#11](https://github.com/bitjourney/mato/pull/11)


## v1.3.1 - 2017/10/12

https://github.com/bitjourney/mato/compare/v1.3.0...v1.3.1


* Exclude `example/` from the package not to confuse RubyMine

## v1.3.0 - 2017/09/26

https://github.com/bitjourney/mato/compare/v1.2.3...v1.3.0

* Added `timeout:`, `on_timeout:` and `on_error:` options to `append_*_filter` [#10](https://github.com/bitjourney/mato/pull/10)


## v1.2.3 - 2017/09/22

https://github.com/bitjourney/mato/compare/v1.2.2...v1.2.3

* Requires rouge v3.0.0 or later with simpler code [#9](https://github.com/bitjourney/mato/pull/9)

## v1.2.2 - 2017/08/31

https://github.com/bitjourney/mato/compare/v1.2.0...v1.2.2

* Added hyphen(-) to MENTION_PATTERN [#8](https://github.com/bitjourney/mato/pull/8)

## v1.2.0 - 2017/08/28

https://github.com/bitjourney/mato/compare/v1.1.0...v1.2.0

* *Experimental*: `Mato::Processor#convert` to convert X-flavored markdown to CommonMark
  * Currently only `flavor: :redcarpet` is supported

## v1.1.0 - 2017/08/24

https://github.com/bitjourney/mato/compare/v1.0.3...v1.1.0

* wrap single, bare `<img/>` with `<p/>` [#6](https://github.com/bitjourney/mato/pull/6)

## v1.0.3 - 2017/08/23

https://github.com/bitjourney/mato/compare/v1.0.2...v1.0.3

* fix issues that tags are remvoed from ToC (degraded in #4, fixed in [#5](https://github.com/bitjourney/mato/pull/5))

## v1.0.2 - 2017/08/23

https://github.com/bitjourney/mato/compare/v1.0.1...v1.0.2

* fix #3's issue again [#4](https://github.com/bitjourney/mato/pull/4)

## v1.0.1 - 2017/08/22

https://github.com/bitjourney/mato/compare/v1.0.0...v1.0.1

* fix issues when headings includes links [#3](https://github.com/bitjourney/mato/pull/3)

## v1.0.0 - 2017/08/08

* Initial stable version
