# frozen_string_literal: true

module Mato
  module Renderers
    module HtmlRenderer
      # @param [Nokogiri::XML::Node] node
      # @return [String]
      def self.call(node)
        node.to_html
      end
    end
  end
end
