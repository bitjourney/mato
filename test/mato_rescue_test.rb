# frozen_string_literal: true

require_relative './test_helper'

class MatoRescueTest < MyTest
  def test_text_filters
    error = nil
    mato = Mato.define do |config|
      config.append_text_filter(->(text) {
        raise 'Hello!'
      }, on_error: ->(e) { error = e })
    end

    doc = mato.process('Hello, world!')

    assert do
      doc.render_html == "<p>Hello, world!</p>\n"
    end

    assert do
      error.message == 'Hello!'
    end
  end
end
