# frozen_string_literal: true

require_relative '../anchor_builder'

module Mato
  module HtmlFilters
    class SectionAnchor

      HX_PATTERN = 'h1,h2,h3,h4,h5,h6'

      def initialize(anchor_icon_element = AnchorBuilder::DEFAULT_ANCHOR_ICON_ELEMENT)
        @anchor_icon_element = anchor_icon_element
      end

      # @param [Nokogiri::HTML::DocumentFragment] doc
      def call(doc)
        anchor_builder = AnchorBuilder.new(@anchor_icon_element)

        doc.css(HX_PATTERN).each do |hx|
          hx.children = anchor_builder.make_anchor_element(hx) + hx.children.to_html
        end
      end
    end
  end
end
