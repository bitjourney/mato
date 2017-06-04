# frozen_string_literal: true

require 'mato'

# User class that mocks ActiveRecord's
class User < Struct.new(:account)

  VALID_ACCOUNTS = %w(mato)

  # @return [Enumerable<User>]
  def self.where(account:)
    (account & VALID_ACCOUNTS).map do |name|
      User.new(name)
    end
  end
end

mato = Mato.define do |config|
  config.append_text_filter -> (text, _context) {
    # weave text
  }

  config.append_markdown_filter -> (doc, _context) {
    # weave doc
  }

  config.append_html_filter -> (doc, _context) {
    # weave doc
  }
  config.append_html_filter(Mato::HtmlFilters::MentionLink.new do |mention_candidate_map|
    candidate_accounts = mention_candidate_map.keys.map { |name| name.gsub(/^\@/, '') }
    User.where(account: candidate_accounts).each do |user|
      mention = user.account
      mention_candidate_map["@#{mention}"].each do |node|
        node.replace("<a href='https://twitter.com/#{mention}' class='mention'>#{mention}</a>")
      end
    end
  end)
end

puts mato.process(<<~'MARKDOWN').render_html
  # Hello, @mato!

  @this_is_invalid_mention

  https://twitter.com/@kibe_la

  * a
    * b
      * c
MARKDOWN
