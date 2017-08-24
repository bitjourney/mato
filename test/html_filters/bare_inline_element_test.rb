# frozen_string_literal: true

require_relative '../test_helper'

require 'sanitize'

class BareInlineElementTest < FilterTest

  def subject
    Mato::HtmlFilters::BareInlineElement.new
  end

  def test_mention_filter_to_work
    source = '<img src="foo.png">'
    assert_html_eq(process(source).render_html, %{<p>#{source}</p>\n})
  end
end
