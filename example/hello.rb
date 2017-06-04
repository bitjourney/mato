# frozen_string_literal: true

require 'mato'

mato = Mato.define do |config|
  config.append_text_filter -> (text, _context) {
    # weave text
  }

  config.append_markdown_filter -> (doc, _context) {
    # weave doc
  }

  config.append_html_filter -> (doc,  _context) {
    # weave doc
  }
  config.append_html_filter(Mato::HtmlFilters::TokenLink.new(Mato::HtmlFilters::TokenLink::MENTION) do |mention|
    "<a href='https://twitter.com/#{mention}' class='mention'>#{mention}</a>"
  end)
end

puts mato.process(<<~'MARKDOWN').render_html
  # Hello, @mato!

  https://twitter.com/@kibe_la

  * a
    * b
      * c
MARKDOWN
