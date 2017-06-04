# frozen_string_literal: true

require_relative '../concerns/html_node_checkable'

module Mato
  module HtmlFilters
    class MentionLink
      include Concerns::HtmlNodeCheckable

      # @return [Regexp]
      attr_reader :pattern

      # @return [Proc]
      attr_reader :link_builder

      MENTION_PATTERN = /\@[a-zA-Z0-9_]+\b/ # e.g. @foo

      # @param [Regexp] pattern
      # @param [Proc] finder
      # @param [Proc] link_builder
      def initialize(pattern = MENTION_PATTERN, &link_builder)
        @pattern = pattern
        @link_builder = link_builder
      end

      # @param [Nokogiri::XML::Node] node
      def call(node, _context = nil)
        candidate_map = {}

        node.xpath('.//text()').each do |text_node|
          next if has_ancestor?(text_node, 'a', 'code')

          text_node.content.scan(pattern) do |mention|
            (candidate_map[mention] ||= []) << text_node
          end
        end

        link_builder.call(candidate_map)
      end
    end
  end
end
