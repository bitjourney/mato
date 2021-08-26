# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'mato'

require 'minitest/autorun'
require 'minitest/power_assert'
require 'active_support'
require 'rr'

class MyTest < MiniTest::Test
  include Minitest::PowerAssert::Assertions

  def assert_html_eq(actual, expected)
    if actual != expected
      s = +""
      s << "expected:\n#{expected}\n"
      s << "-----------------"
      s << "got:\n#{actual}\n"
      s << "-----------------"
      s << "diff:\n#{diff(expected, actual)}"
      s << "-----------------"
      flunk s
    end
  end
end

class FilterTest < MyTest

  def subject
    raise "You must define subject"
  end

  # @return [Mato::Processor]
  def mato
    @mato ||= Mato.define do |config|
      config.append_html_filter(subject)
    end
  end

  # @param [String] markdown
  # @return [Mato::Document]
  def process(markdown)
    mato.process(markdown)
  end
end
