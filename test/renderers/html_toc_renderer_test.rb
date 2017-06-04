# frozen_string_literal: true

require_relative '../test_helper'

class HtmlTocRendererTest < Minitest::Test
  def subject
    @subject ||= Mato::Renderers::HtmlTocRenderer.new
  end

  def test_simle
    assert do
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

      subject.call(Nokogiri::HTML.fragment(input)) == output
    end
  end
end
