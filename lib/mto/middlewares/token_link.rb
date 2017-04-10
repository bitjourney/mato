# frozen_string_literal: true

module Mto
  module Middlewares
    class TokenLink
      include Mto::Middleware

      input Nokogiri::XML::Node
      output Nokogiri::XML::Node

      # @return [Regexp]
      attr_reader :pattern

      # @return [Proc]
      attr_reader :builder

      MENTION = %r{\@[a-zA-Z0-9_]+\b}

      # @param [Regexp] pattern
      def initialize(pattern, &builder)
        @pattern = pattern
        @builder = builder
      end

      # @param [Nokogiri::XML::Node] node
      # @return [Nokogiri::XML::Node]
      def call(node)
        node.xpath('.//text()').each do |text_node|
          next if has_ancestor?(text_node, 'a', 'code')
          text_node.replace(text_node.content.gsub(pattern, &builder))
        end
        node
      end

      # @param [Nokogiri::XML::Node] node
      # @return [Boolean]
      def has_ancestor?(node, *tags)
        current = node
        while (current = current.parent)
          if tags.include?(current.name)
            return true
          end
        end
        false
      end
    end
  end
end
