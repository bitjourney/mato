# frozen_string_literal: true

require_relative '../test_helper'

class SectionAnchorTest < FilterTest
  def subject
    Mato::HtmlFilters::SectionAnchor.new
  end

  def test_simple
    assert_html_eq(process('# foo').render_html, <<~'HTML')
      <h1>
      <a id="foo" href="#foo" aria-hidden="true"><i class="fa fa-link"></i></a>foo</h1>
    HTML
  end
end
