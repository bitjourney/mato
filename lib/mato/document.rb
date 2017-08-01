
# frozen_string_literal: true

require_relative './renderers/html_renderer'
require_relative './renderers/html_toc_renderer'

# Intermediate document class, which instance is *serializable*.
module Mato
  class Document
    # @return [Nokogiri::XML::Element]
    attr_reader :fragment

    # @param [Nokogiri::XML::Element] fragment
    def initialize(fragment)
      @fragment = fragment
    end

    # @param [String] selector
    # @return [Nokogiri::XML::NodeSet]
    def css(selector)
      fragment.css(selector)
    end

    # @param [String] query
    # @return [Nokogiri::XML::NodeSet]
    def xpath(query)
      fragment.xpath(query)
    end

    def render(renderer)
      renderer.call(fragment)
    end

    def render_html
      render(Mato::Renderers::HtmlRenderer.new)
    end

    def render_html_toc
      render(Mato::Renderers::HtmlTocRenderer.new)
    end

    def marshal_dump
      {
        fragment: fragment.to_s,
      }
    end

    def marshal_load(data)
      initialize(Nokogiri::HTML.fragment(data[:fragment]))
    end
  end
end
