# Mato - Markdown Toolkit based on CommonMark [![Build Status](https://travis-ci.org/bitjourney/mato.svg?branch=master)](https://travis-ci.org/bitjourney/mato)

**Mato**, standing for **Ma**rkdown **To**oolkit,  is an extensible markdown-based content processing toolkit, inspired by [HTML::Pipeline](https://github.com/jch/html-pipeline).


This gem is built on [commonmarker](https://github.com/gjtorikian/commonmarker), a [CommonMark](https://github.com/jgm/CommonMark) implementation,
which can parse markdown documents into AST.

## Synopsis

```ruby
require 'mato'

# define a markdown-to-html processor:
mato = Mato.define do |config|
  # append pre-defined HTML filters:
  config.append_html_filter(Mato::HtmlFilters::SyntaxHighlight.new)
  config.append_html_filter(Mato::HtmlFilters::TaskList.new)
  config.append_html_filter(Mato::HtmlFilters::SectionAnchor.new)

  # append MentionLink, a customizable HTML filter:
  config.append_html_filter(Mato::HtmlFilters::MentionLink.new do |mention_candidate_map|
    candidate_accounts = mention_candidate_map.keys.map { |name| name.gsub(/^\@/, '') }
    User.where(account: candidate_accounts).each do |user|
      mention = "@#{user.account}"
      mention_candidate_map[mention].each do |node|
        node.replace("<a href='https://twitter.com/#{mention}' class='mention'>#{mention}</a>")
      end
    end
  end)
end

# Prosesses markdown into Mato::Document:
doc = mato.process(markdown_content)

# Renders doc as HTML:
html = doc.render_html

# Renders doc as HTML Table of Contents:
html_toc = doc.render_html_toc

# Extracts elements (e.g. mentions) with CSS selector:
doc.css('a').each do |element|
  # do something with element: Nokogiri::XML::Element
end

# Extracts nodes (e.g. mentions) with XPath selector:
doc.xpath('./text()').each do |node|
  # do something with node: Nokogiri::XML::Text
end

# Mato::Document can be cached with Rails.cache (i.e. Marshal.dump ready)
Rails.fetch(digest(markdown_content)) do
  mato.process(markdown_content)
end

# Applies extra filters and returns a new Mato::Document.
# Because Mato::Document is serializable, you can cache the base doc and then apply extra filters on demaond.
new_doc = doc.apply_html_filters(
  -> (fragment) { modify_fragment!(fragment) },
  SomeHtmlFilter.new, # anything that has #call(node) method
)
```

## Installation

Add this line to your application's Gemfile:

```ruby:Gemfile
gem 'mato'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mato

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bitjourney/mato.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

