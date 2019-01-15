# frozen_string_literal: true

require_relative '../test_helper'

class SectionAnchorTest < FilterTest
  def subject
    Mato::HtmlFilters::SectionAnchor.new
  end

  def test_simple
    assert_html_eq(process('# foo').render_html, <<~'HTML')
      <h1>
      <a id="foo" href="#foo" aria-hidden="true" class="anchor"><i class="fa fa-link"></i></a>foo</h1>
    HTML
  end

  def test_only_special_characters
    assert_html_eq(process("# ?\n# ?").render_html, <<~'HTML')
      <h1>
      <a id="user-content" href="#user-content" aria-hidden="true" class="anchor"><i class="fa fa-link"></i></a>?</h1>
      <h1>
      <a id="user-content-1" href="#user-content-1" aria-hidden="true" class="anchor"><i class="fa fa-link"></i></a>?</h1>
    HTML
  end
end
