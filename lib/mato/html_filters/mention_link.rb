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
      # @param [Proc] link_builder A block that takes Hash<String, Array<Nokogiri::XML::Node>>
      def initialize(pattern = MENTION_PATTERN, &link_builder)
        @pattern = pattern
        @link_builder = link_builder
      end

      # @param [Nokogiri::XML::Node] node
      def call(node, _context = nil)
        candidates = []

        node.xpath('.//text()').each do |text_node|
          next if has_ancestor?(text_node, 'a', 'code', 'pre')

          fragment = text_node.content.gsub(pattern) do |mention|
            "<span>#{mention}</span>"
          end

          next if text_node.content == fragment

          candidates << text_node.replace(fragment)
        end

        candidate_map = {}
        candidates.each do |candidate|
          candidate.search('span').each do |mention_element|
            (candidate_map[mention_element.child.content] ||= []) << mention_element
          end
        end

        unless candidate_map.empty?
          link_builder.call(candidate_map)
        end
      end
    end
  end
end
