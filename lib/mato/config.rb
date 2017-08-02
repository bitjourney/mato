# frozen_string_literal: true

require_relative('./document')

module Mato
  class Config
    # https://github.com/gjtorikian/commonmarker#parse-options
    DEFAULT_MARKDOWN_PARSE_OPTIONS = %i[
      DEFAULT
      VALIDATE_UTF8
    ]

    # https://github.com/gjtorikian/commonmarker#render-options
    DEFAULT_MARKDOWN_RENDER_OPTIONS = [
      :DEFAULT,
      :HARDBREAKS, # convert "\n" as <br/>
      # :SOURCEPOS, // TODO: enable it after assertions are supported
    ]

    # https://github.com/github/cmark/tree/master/extensions
    DEFAULT_MARKDOWN_EXTENSIONS = %i[
      table
      strikethrough
      autolink
      tagfilter
    ]

    # @return [Array<Proc>]
    attr_reader :text_filters

    # @return [Array<Proc>]
    attr_reader :markdown_filters

    # @return [Array<Proc>]
    attr_reader :html_filters

    # @return [Class<CommonMarker]
    attr_reader :markdown_parser

    # @return [Cass<Nokogiri::HTML::DocumentFragment>]
    attr_reader :html_parser

    # @return [Class<Mato::Document>]
    attr_reader :document_factory

    # @return [Array<Symbol>] CommonMarker's parse extensions
    attr_reader :markdown_extensions

    # @return [Array<Symbol>] CommonMarker's pars options
    attr_reader :markdown_parse_options

    # @return [Array<Symbol>] CommonMarker's HTML rendering options
    attr_reader :markdown_render_options

    def initialize
      @text_filters = []
      @markdown_filters = []
      @html_filters = []

      @markdown_parser = CommonMarker
      @html_parser = Nokogiri::HTML::DocumentFragment

      @document_factory = Document

      @markdown_extensions = DEFAULT_MARKDOWN_EXTENSIONS
      @markdown_parse_options = DEFAULT_MARKDOWN_PARSE_OPTIONS
      @markdown_render_options = DEFAULT_MARKDOWN_RENDER_OPTIONS
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
