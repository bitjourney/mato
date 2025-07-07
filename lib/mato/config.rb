# frozen_string_literal: true

require_relative('./document')

require 'nokogiri'

module Mato
  class Config
    DEFAULT_MARKDOWN_OPTIONS = {
      render: {
        hardbreaks: true,
        unsafe: true,
        escaped_char_spans: false,
      },
      extension: {
        table: true,
        strikethrough: true,
        autolink: true,
        tagfilter: true,
        tasklist: false,
        shortcodes: false,
        footnotes: true,
      },
    }.freeze

    # @return [Array<Proc>]
    attr_accessor :text_filters

    # @return [Array<Proc>]
    attr_accessor :markdown_filters

    # @return [Array<Proc>]
    attr_accessor :html_filters

    # @return [Class<Commonmarker]
    attr_accessor :markdown_parser

    # @return [Cass<Nokogiri::HTML4::DocumentFragment>]
    attr_accessor :html_parser

    # @return [Class<Mato::Document>]
    attr_accessor :document_factory

    # @return [Hash] Commonmarker's options
    attr_accessor :markdown_options

    # @return [Hash] Commonmarker's plugins
    attr_accessor :markdown_plugins

    def initialize
      @text_filters = []
      @markdown_filters = []
      @html_filters = []

      @markdown_parser = Commonmarker
      @html_parser = Nokogiri::HTML4::DocumentFragment

      @document_factory = Document

      @markdown_options = DEFAULT_MARKDOWN_OPTIONS
      @markdown_plugins = { syntax_highlighter: nil }
    end

    # @param [Proc] block
    # @yieldparam [Mato::Config] config
    def configure(&block)
      block.call(self)
    end

    def append_text_filter(text_filter, timeout: nil, on_timeout: nil, on_error: nil)
      raise "text_filter must respond to call()" unless text_filter.respond_to?(:call)

      text_filters.push(wrap(text_filter, timeout: timeout, on_timeout: on_timeout, on_error: on_error))
    end

    def append_markdown_filter(markdown_filter, timeout: nil, on_timeout: nil, on_error: nil)
      raise "markdown_filter must respond to call()" unless markdown_filter.respond_to?(:call)

      markdown_filters.push(wrap(markdown_filter, timeout: timeout, on_timeout: on_timeout, on_error: on_error))
    end

    def append_html_filter(html_filter, timeout: nil, on_timeout: nil, on_error: nil)
      raise "html_filter must respond to call()" unless html_filter.respond_to?(:call)

      html_filters.push(wrap(html_filter, timeout: timeout, on_timeout: on_timeout, on_error: on_error))
    end

    private

    def wrap(filter, timeout:, on_timeout:, on_error:)
      if timeout
        filter = Mato::Timeout.new(filter, timeout: timeout, on_timeout: on_timeout || on_error)
      end

      if on_error
        filter = Mato::Rescue.new(filter, on_error: on_error)
      end

      filter
    end
  end
end
