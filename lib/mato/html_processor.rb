# frozen_string_literal: true

require 'commonmarker'
require 'nokogiri'

module Mato
  class HtmlProcessor
    # @param [CommonMarker::Node] markdown_node
    # @return [Nokogiri;:XML::Node]
    def call(markdown_node, _context = nil)
      Nokogiri::HTML.fragment(markdown_node.to_html)
    end
  end
end
