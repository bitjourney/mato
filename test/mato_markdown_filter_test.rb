# frozen_string_literal: true

require_relative './test_helper'
require 'pp'

class MatoMarkdownFilterTest < MyTest
  def test_text_filters
    mato = Mato.define do |config|
      config.append_markdown_filter(->(doc) {
        paragraph = doc.first_child
        text_node = paragraph.first_child
        text_node.string_content = text_node.string_content.upcase
      })
    end

    doc = mato.process('Hello, world!')

    assert do
      doc.render_html == "<p>HELLO, WORLD!</p>\n"
    end
  end
end
