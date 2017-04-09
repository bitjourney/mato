# Mdto - Markdown Processing Toolkit

**Mdto** is an extensible markdown-based content processing toolkit, inspired in [HTML::Pipeline](https://github.com/jch/html-pipeline).

The `Mdto` library converts markdown texts into some other format like HTML, as the following processes:

*  Plain-text filtes processes the input source markdown text
* A markdown processor translates a markdown content into CommonMark AST (sometimes called "Markdown Document")
* CommonMark AST filters processes the AST
* A markdown renderer renders AST into a HTML node (i.e.`Nokogiri::XML::Node`)
* HTML filters processes the HTML node
* A formatter converts the HTML node into an HTML representation, plain text, and so on

Simply, it converts markdown into HTML with various middlewares applied.

This gem is built on [commonmarker](https://github.com/gjtorikian/commonmarker), a [CommonMark](https://github.com/jgm/CommonMark) implementation,
which can parse markdown documents into AST.

## Synopsis

```ruby
# markdown to html:
mdto = Mdto.define do |config|
    config.cache Rails.cache

    config.use Mdto::Middlewares::CommonMark
    config.use Mdto::Middlewares::AutoLink
    config.use Mdto::Middlewares::SyntaxHighlight

    # use a custom middleware
    config.use MyApp::SomethingGreat
end

# render markdown as HTML:
html = mdto.process(markdown_content).render_html

# same as the above, applying an extra middleware MDto::Middlewares::StripScript
html = mdto.process(markdown_content).apply(Mdto::Middlewares::StripScript).render_html

# render markdown as HTML ToC:
html_toc = mdto.process(markdown_content).render_html_toc

# render markdown as plain text with a custom renderer:
text = mdto.process(markdown_content).render_text

# extract links:
links  = mdto.process(markdown_content).reduce([]) do |document, links|
    # document is a Nokogiri::HTML::Node
    links << extract_links(document)
end
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mdto'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mdto

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mdto.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

