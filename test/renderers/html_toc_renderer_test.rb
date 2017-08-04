# frozen_string_literal: true

require_relative '../test_helper'

class HtmlTocRendererTest < MyTest

  # @return [Mato::Renderers::HtmlTocRenderer]
  def subject
    @subject ||= Mato::Renderers::HtmlTocRenderer.new
  end

  def test_simple
    input = <<~'HTML'
      <h1>first</h1>
      <h2>second</h2>
      <h5>fifth</h5>
      <h1>first</h1>
    HTML

    output = <<~'HTML'
      <ul>
      <li>first<ul>
      <li>second<ul>
      <li>fifth</li></ul>
      </li></ul>
      <li>first</li></ul>
    HTML

    assert_html_eq(subject.call(Nokogiri::HTML.fragment(input)), output)
  end

  def test_with_anchor
    mato = Mato.define do |config|
      config.append_html_filter(Mato::HtmlFilters::SectionAnchor.new)
    end

    input = <<~'HTML'
      <h1>ほげ</h1>
      <h2>ほげ</h2>
      <h3>foo "bar" baz</h3>
    HTML

    output = <<~'HTML'
      <ul>
      <li><a href="#%E3%81%BB%E3%81%92">ほげ</a><ul>
      <li><a href="#%E3%81%BB%E3%81%92-1">ほげ</a><ul>
      <li><a href="#foo-bar-baz">foo "bar" baz</a></li></ul>
      </li></ul>
      </li></ul>
    HTML

    assert_html_eq(mato.process(input).render_html_toc, output)

    assert_html_eq(Marshal.load(Marshal.dump(mato.process(input))).render_html_toc, output)
  end
end
