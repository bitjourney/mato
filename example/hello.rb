# frozen_string_literal: true

require 'mdto'

mdto = Mdto.define do |config|
  config.use Mdto::Middlewares::CommonMark
  config.use Mdto::Middlewares::ToHtmlNode
  config.use Mdto::Middlewares::TokenLink.new(Mdto::Middlewares::TokenLink::MENTION) { |mention|
    "<a href='https://twitter.com/#{mention}' class='mention'>#{mention}</a>"
  }
end

puts mdto.process(<<~'MARKDOWN').render_html
  # Hello, @mdto!

  https://twitter.com/@kibe_la

  * a
    * b
      * c
MARKDOWN
