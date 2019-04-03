# frozen_string_literal: true

require_relative './test_helper'

class MatoTimeoutTest < MyTest
  def test_text_filters
    timeout = nil
    mato = Mato.define do |config|
      config.append_text_filter(->(text) {
        sleep
      }, timeout: 0.1, on_timeout: ->(e) { timeout = e })
    end

    doc = mato.process('Hello, world!')

    assert do
      doc.render_html == "<p>Hello, world!</p>\n"
    end

    assert do
      timeout.is_a?(Timeout::Error)
    end
  end

  def test_text_filters_with_on_error
    timeout = nil
    mato = Mato.define do |config|
      config.append_text_filter(->(text) {
        sleep
      }, timeout: 0.1, on_error: ->(e) { timeout = e })
    end

    doc = mato.process('Hello, world!')

    assert do
      doc.render_html == "<p>Hello, world!</p>\n"
    end

    assert do
      timeout.is_a?(Timeout::Error)
    end
  end
end
