# frozen_string_literal: true

require_relative './renderers/html_renderer'
require_relative './renderers/html_toc_renderer'

# Intermediate document class, which instance is *serializable*.
module Mato
  class Document
    # @return [Nokogiri::HTML::DocumentFragment]
    attr_reader :fragment

    def self.empty
      new(Nokogiri::HTML.fragment(''))
    end

    # @param [Nokogiri::HTML::DocumentFragment] fragment
    def initialize(fragment)
      @fragment = fragment
    end

    # @return [Nokogiri::HTML::DocumentFragment] A copy of fragment that are modified by html_filters
    def apply_html_filters(*html_filters)
      new_fragment = fragment.dup
      html_filters.each do |html_filter|
        html_filter.call(new_fragment)
      end
      self.class.new(new_fragment.freeze)
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
        fragment: fragment.to_html(save_with: 0),
      }
    end

    def marshal_load(data)
      initialize(Nokogiri::HTML.fragment(data[:fragment]).freeze)
    end
  end
end
