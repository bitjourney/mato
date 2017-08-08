# frozen_string_literal: true

require_relative './test_helper'

class MatoHtmlFilterTest < MyTest
  def test_text_filters
    mato = Mato.define do |config|
      config.append_html_filter(->(doc) {
        text_node = doc.xpath('.//text()').first
        text_node.content = text_node.content.upcase
      })
    end

    doc = mato.process('Hello, world!')

    assert do
      doc.render_html == "<p>HELLO, WORLD!</p>\n"
    end
  end
end
