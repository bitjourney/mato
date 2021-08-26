# frozen_string_literal: true

module Mato
  module Renderers
    class HtmlRenderer
      # @param [Nokogiri::HTML4::DocumentFragment] doc
      # @return [String]
      def call(doc)
        doc.to_html
      end
    end
  end
end
