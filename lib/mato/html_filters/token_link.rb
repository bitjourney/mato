# frozen_string_literal: true

require_relative '../concerns/html_node_checkable'

module Mato
  module HtmlFilters
    class TokenLink
      include Concerns::HtmlNodeCheckable

      # @return [Regexp]
      attr_reader :pattern

      # @return [Proc]
      attr_reader :builder

      # @param [Regexp] pattern
      # @param [Procc] builder link builder that takes
      def initialize(pattern, &builder)
        @pattern = pattern
        @builder = builder
      end

      # @param [Nokogiri::XML::Node] node
      def call(node, _context = nil)
        node.xpath('.//text()').each do |text_node|
          next if has_ancestor?(text_node, 'a', 'code')

          text_node.replace(text_node.content.gsub(pattern, &builder))
        end
      end
    end
  end
end
