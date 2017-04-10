# frozen_string_literal: true

require 'commonmarker'
require 'nokogiri'

module Mdto
  module Middlewares
    class ToHtmlNode
      include Mdto::Middleware

      input CommonMarker::Node
      output Nokogiri::XML::Node

      # @param [CommonMarker::Node] markdown_node
      # @return [Nokogiri;:XML::Node]
      def call(markdown_node)
        Nokogiri::HTML.fragment(markdown_node.to_html)
      end
    end
  end
end
