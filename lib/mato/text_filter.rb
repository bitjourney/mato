# frozen_string_literal: true

require_relative('./abstract_method_error')

module Mato
  class TextFilter
    def call(_text, _context)
      raise AbstractMethodError, :call
    end
  end
end
