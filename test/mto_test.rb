# frozen_string_literal: true

require_relative './test_helper'

class MtoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Mto::VERSION
  end

  def test_it_does_something_useful
    mto = Mto.define do |config|
      config.use Mto::Middlewares::CommonMark.new
      config.use Mto::Middlewares::ToHtmlNode
    end

    assert { mto.process('Hello, world!').render_html == "<p>Hello, world!</p>\n" }
  end
end
