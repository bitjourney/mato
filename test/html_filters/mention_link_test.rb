# frozen_string_literal: true

require_relative '../test_helper'

class MentionLinkTest < Minitest::Test

  class User < Struct.new(:account)

    VALID_ACCOUNTS = %w(valid)

    # @return [Enumerable<User>]
    def self.where(account:)
      (account & VALID_ACCOUNTS).map do |name|
        User.new(name)
      end
    end
  end

  def mato
    @mato ||= Mato.define do |config|
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
  end

  def test_mention_filter_for_valid
    assert { mato.process('@valid').render_html == %{<p><a href="https://twitter.com/@valid" class="mention">@valid</a></p>\n} }
  end

  def test_mention_filter_for_invalid
    assert { mato.process('@invalid').render_html == %{<p>@invalid</p>\n} }
  end

  def test_mention_filter_for_valid_in_a
    assert { mato.process('<a>@valid</a>').render_html == %{<p><a>@valid</a></p>\n} }
  end

  def test_mention_filter_for_valid_in_code
    assert { mato.process('<code>@valid</code>').render_html == %{<p><code>@valid</code></p>\n} }
  end
end
