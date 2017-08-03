# frozen_string_literal: true

require_relative '../test_helper'

require 'sanitize'

class SanitizationTest < FilterTest

  def subject
    Mato::HtmlFilters::Sanitization.new(sanitize: Sanitize.new(Sanitize::Config::RESTRICTED))
  end

  def test_mention_filter_to_work
    assert_html_eq process('<img src="foo.png">').render_html, %{\n}
  end
end
