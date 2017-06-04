# frozen_string_literal: true

require 'mato'

mato = Mato.define do |config|
  config.use Mato::Middlewares::CommonMark
  config.use Mato::Middlewares::ToHtmlNode
  config.use Mato::Middlewares::TokenLink.new(Mato::Middlewares::TokenLink::MENTION) { |mention|
    "<a href='https://twitter.com/#{mention}' class='mention'>#{mention}</a>"
  }
end

puts mato.process(<<~'MARKDOWN').render_html
  # Hello, @mato!

  https://twitter.com/@kibe_la

  * a
    * b
      * c
MARKDOWN
