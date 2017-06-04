# frozen_string_literal: true

require_relative('./abstract_method_error')

module Mato
  class HtmlFilter
    def call(_html_node, _context)
      raise AbstractMethodError, :call
    end
  end
end
