# frozen_string_literal: true

require_relative './test_helper'

class MatoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Mato::VERSION
  end

  def test_it_does_something_useful
    mato = Mato.define do |config|
      config.use Mato::Middlewares::CommonMark.new
      config.use Mato::Middlewares::ToHtmlNode
    end

    assert { mato.process('Hello, world!').render_html == "<p>Hello, world!</p>\n" }
  end
end
