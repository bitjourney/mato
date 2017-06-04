
# frozen_string_literal: true

require_relative './renderers/html_renderer'

# Intermediate Document
module Mato
  class Document
    attr_reader :node
    attr_reader :context

    # @param [Nokogiri::XML::Node] node
    # @param [Mato::Context] context
    def initialize(html_node, context)
      @node = html_node
      @context = context
    end

    def render_html
      Mato::Renderers::HtmlRenderer.new.call(@node, @context)
    end
  end
end
