# frozen_string_literal: true

require_relative('./text_filter')
require_relative('./markdown_filter')
require_relative('./html_filter')

require_relative('./markdown_processor')
require_relative('./html_processor')

require_relative('./context')
require_relative('./document')

module Mato
  class Config
    # @return [Array<Mato::TextFilter>]
    attr_reader :text_filters

    # @return [Array<Mato::MarkdownFilter>]
    attr_reader :markdown_filters

    # @return [Array<Mato::HtmlFilter>]
    attr_reader :html_filters

    # @return [Mato::MarkdownProcessor]
    attr_reader :markdown_processor

    # @return [Mato::HtmlProcessor]
    attr_reader :html_processor

    # @return [Class<Mato::Context>]
    attr_reader :context_factory

    # @return [Class<Mato::Document>]
    attr_reader :document_factory

    def initialize
      @text_filters = []
      @markdown_filters = []
      @html_filters = []

      @markdown_processor = MarkdownProcessor.new
      @html_processor = HtmlProcessor.new
      @context_factory = Context
      @document_factory = Document
    end

    # @param [Proc] block
    # @yieldparam [Mato::Config] config
    def configure(&block)
      block.call(self)
    end

    def append_text_filter(text_filter)
      raise "text_filter must respond to call()" unless text_filter.respond_to?(:call)
      text_filters.push(text_filter)
    end

    def prepend_text_filter(text_filter)
      raise "text_filter must respond to call()" unless text_filter.respond_to?(:call)
      text_filters.unshift(text_filter)
    end

    def append_markdown_filter(markdown_filter)
      raise "markdown_filter must respond to call()" unless markdown_filter.respond_to?(:call)
      markdown_filters.push(markdown_filter)
    end

    def prepend_markdown_filter(markdown_filter)
      raise "markdown_filter must respond to call()" unless markdown_filter.respond_to?(:call)
      markdown_filters.unshift(markdown_filter)
    end

    def append_html_filter(html_filter)
      raise "html_filter must respond to call()" unless html_filter.respond_to?(:call)
      html_filters.push(html_filter)
    end

    def prepend_html_filter(html_filter)
      raise "html_filter must respond to call()" unless html_filter.respond_to?(:call)
      html_filters.unshift(html_filter)
    end
  end
end
