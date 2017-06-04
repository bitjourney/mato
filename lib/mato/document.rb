
# frozen_string_literal: true

require_relative './renderers/html_renderer'
require_relative './renderers/html_toc_renderer'

# Intermediate Document
module Mato
  class Document

    attr_reader :node

    # @param [Mato::Config] config
    # @param [Nokogiri::XML::Node] node
    def initialize(config, node)
      @config = config
      @node = node
    end

    def render_html
      Mato::Renderers::HtmlRenderer.call(@node)
    end

    def render_html_toc
      Mato::Renderers::HtmlTocRenderer.call(@node)
    end
  end
end
