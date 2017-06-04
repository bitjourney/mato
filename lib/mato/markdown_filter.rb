# frozen_string_literal: true

require_relative('./abstract_method_error')

module Mato
  class MarkdownFilter
    def call(text, context)
      raise AbstractMethodError, :call
    end
  end
end
