# frozen_string_literal: true

require 'mto'

mto = Mto.define do |config|
  config.use Mto::Middlewares::CommonMark
  config.use Mto::Middlewares::ToHtmlNode
  config.use Mto::Middlewares::TokenLink.new(Mto::Middlewares::TokenLink::MENTION) { |mention|
    "<a href='https://twitter.com/#{mention}' class='mention'>#{mention}</a>"
  }
end

puts mto.process(<<~'MARKDOWN').render_html
  # Hello, @mto!

  https://twitter.com/@kibe_la

  * a
    * b
      * c
MARKDOWN
