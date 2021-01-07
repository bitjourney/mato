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

      MENTION_PATTERN = /\@[a-zA-Z0-9_\-]+\b/ # e.g. @foo

      # @param [Regexp] pattern
      # @param [Proc] link_builder A block that takes Hash<String, Array<Nokogiri::XML::Node>>
      def initialize(pattern = MENTION_PATTERN, &link_builder)
        @pattern = pattern
        @link_builder = link_builder
      end

      # @param [Nokogiri::HTML::DocumentFragment] doc
      def call(doc)
        candidate_map = {}
        candidates = []

        doc.xpath('.//text()').each do |text_node|
          next if has_ancestor?(text_node, 'a', 'code', 'pre')

          candidate_html = text_node.content.gsub(pattern) do |mention|
            "<span class='mention-candidate'>#{mention}</span>"
          end

          next if text_node.content == candidate_html

          candidate_fragment = text_node.replace(candidate_html)
          candidate_fragment.css('span.mention-candidate').each do |mention_element|
            next unless mention_element.child

            (candidate_map[mention_element.child.content] ||= []) << mention_element
          end

          candidates << candidate_fragment
        end

        unless candidate_map.empty?
          link_builder.call(candidate_map)

          # cleanup
          candidates.each do |candidate_fragment|
            candidate_fragment.css('span.mention-candidate').each do |node|
              next unless node.child
              # If link_builder calls Node#replace for a node,
              # the node's parent becames nil.
              # Node#replace doesn't accept node that doesn't have parent since Nokogiri v1.11.0,
              # so we need to skip it.
              next unless node.parent

              node.replace(node.child.content)
            end
          end
        end
      end
    end
  end
end
