# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'mato'

require 'minitest/autorun'
require 'minitest/power_assert'

module MiniTest
  class Test
    def assert_html_eq(got, expected)
      if got != expected
        puts "expected:\n#{expected}"
        puts "-----------------"
        puts "got:\n#{got}"
      end
      assert { got == expected }
    end
  end
end
