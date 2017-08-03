# frozen_string_literal: true

require_relative './test_helper'

class MatoTest < Minitest::Test
  def mato
    @mato ||= Mato.define do |config|
      config.html_parser = Nokogiri::HTML5::DocumentFragment
    end
  end

  def test_it_does_something_useful
    assert do
      mato.process('Hello, world!').render_html == "<p>Hello, world!</p>\n"
    end
  end
end
