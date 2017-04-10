
# frozen_string_literal: true

require_relative './renderers/html_renderer'
require_relative './renderers/html_toc_renderer'

# Intermediate Document
module Mdto
  class Document

    attr_reader :node

    # @param [Mdto::Config] config
    # @param [Nokogiri::XML::Node] node
    def initialize(config, node)
      @config = config
      @node = node
    end

    def render_html
      Mdto::Renderers::HtmlRenderer.call(@node)
    end

    def render_html_toc
      Mdto::Renderers::HtmlTocRenderer.call(@node)
    end
  end
end
