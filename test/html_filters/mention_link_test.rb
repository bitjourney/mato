# frozen_string_literal: true

require_relative '../test_helper'

class MentionLinkTest < FilterTest

  class User < Struct.new(:account)
    VALID_ACCOUNTS = %w(valid)

    # @return [Enumerable<User>]
    def self.where(account:)
      (account & VALID_ACCOUNTS).map do |name|
        User.new(name)
      end
    end
  end

  def subject
    Mato::HtmlFilters::MentionLink.new do |mention_candidate_map|
      candidate_accounts = mention_candidate_map.keys.map { |name| name.gsub(/^\@/, '') }
      User.where(account: candidate_accounts).each do |user|
        mention = "@#{user.account}"
        mention_candidate_map[mention].each do |node|
          node.replace("<a href='https://twitter.com/#{mention}' class='mention'>#{mention}</a>")
        end
      end
    end
  end

  def test_mention_filter_for_valid
    assert_html_eq process('@valid').render_html, %{<p><a href="https://twitter.com/@valid" class="mention">@valid</a></p>\n}
  end

  def test_mention_filter_for_multiple_valid_accounts
    assert_html_eq process('@valid @valid').render_html,
                   %{<p><a href="https://twitter.com/@valid" class="mention">@valid</a> <a href="https://twitter.com/@valid" class="mention">@valid</a></p>\n}
  end

  def test_mention_filter_for_invalid
    assert_html_eq process('@invalid').render_html, %{<p><span>@invalid</span></p>\n}
  end

  def test_mention_filter_for_valid_in_a
    assert_html_eq process('<a>@valid</a>').render_html, %{<p><a>@valid</a></p>\n}
  end

  def test_mention_filter_for_valid_in_code
    assert_html_eq process('<code>@valid</code>').render_html, %{<p><code>@valid</code></p>\n}
  end
end
