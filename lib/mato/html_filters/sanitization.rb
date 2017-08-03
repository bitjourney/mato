# frozen_string_literal: true

# note: do require 'sanitize' by yourself

# https://github.com/rgrove/sanitize
module Mato
  module HtmlFilters
    class Sanitization
      attr_reader :sanitize

      # @param [Sanitize] sanitize
      def initialize(sanitize:)
        @sanitize = sanitize
      end

      def call(doc)
        sanitize.node!(doc)
      end
    end
  end
end
