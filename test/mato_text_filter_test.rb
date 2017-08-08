# frozen_string_literal: true

require_relative './test_helper'

class MatoTextFilterTest < MyTest
  def test_text_filters
    mato = Mato.define do |config|
      config.append_text_filter(->(text) {
        text.upcase
      })
    end

    doc = mato.process('Hello, world!')

    assert do
      doc.render_html == "<p>HELLO, WORLD!</p>\n"
    end
  end
end
