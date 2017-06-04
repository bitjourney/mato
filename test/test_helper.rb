# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'mato'

require 'minitest/autorun'
require 'minitest/power_assert'

class MiniTest::Test
  def assert_html_eq(got, expected)
    if got != expected
      puts "expected:\n#{expected}"
      puts "-----------------"
      puts "got:\n#{got}"
    end
  end
end
