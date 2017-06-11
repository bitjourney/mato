
# frozen_string_literal: true

require_relative './renderers/html_renderer'
require_relative './renderers/html_toc_renderer'

# Intermediate Document
module Mato
  class Document
    # @return [Nokogiri::XML::Node]
    attr_reader :node

    # @return [Mato::Context]
    attr_reader :context

    # @param [Nokogiri::XML::Node] node
    # @param [Mato::Context] context
    def initialize(html_node, context)
      @node = html_node
      @context = context
    end

    def render(renderer)
      renderer.call(@node, @context)
    end

    def render_html
      render(Mato::Renderers::HtmlRenderer.new)
    end

    def render_html_toc
      render(Mato::Renderers::HtmlTocRenderer.new)
    end
  end
end
