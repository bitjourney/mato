
# frozen_string_literal: true

require_relative './renderers/html_renderer'
require_relative './renderers/html_toc_renderer'

# Intermediate document class, which instance is *serializable*.
module Mato
  class Document
    # @return [Nokogiri::XML::Node]
    attr_reader :node

    # @param [Nokogiri::XML::Node] node
    def initialize(node)
      @node = node
    end

    def render(renderer)
      renderer.call(@node)
    end

    def render_html
      render(Mato::Renderers::HtmlRenderer.new)
    end

    def render_html_toc
      render(Mato::Renderers::HtmlTocRenderer.new)
    end

    def marshal_dump
      {
        html: node.to_s,
      }
    end

    def marshal_load(data)
      initialize(Nokogiri::HTML.fragment(data[:html]))
    end
  end
end
