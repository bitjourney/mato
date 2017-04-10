# frozen_string_literal: true

require_relative './test_helper'

class MdtoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Mdto::VERSION
  end

  def test_it_does_something_useful
    mdto = Mdto.define do |config|
      config.use Mdto::Middlewares::CommonMark.new
      config.use Mdto::Middlewares::ToHtmlNode
    end

    assert { mdto.process('Hello, world!').render_html == "<p>Hello, world!</p>\n" }
  end
end
