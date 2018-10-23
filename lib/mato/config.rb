# frozen_string_literal: true

require_relative('./document')

require 'nokogiri'

module Mato
  class Config
    # https://github.com/gjtorikian/commonmarker#parse-options
    DEFAULT_MARKDOWN_PARSE_OPTIONS = %i[
      DEFAULT
      VALIDATE_UTF8
      FOOTNOTES
    ].freeze

    # https://github.com/gjtorikian/commonmarker#render-options
    DEFAULT_MARKDOWN_RENDER_OPTIONS = [
      :DEFAULT,
      :HARDBREAKS, # convert "\n" as <br/>
      :TABLE_PREFER_STYLE_ATTRIBUTES,
      :UNSAFE,
      # :SOURCEPOS, // TODO: enable it after assertions are supported
    ].freeze

    # https://github.com/github/cmark/tree/master/extensions
    DEFAULT_MARKDOWN_EXTENSIONS = %i[
      table
      strikethrough
      autolink
      tagfilter
    ].freeze

    # @return [Array<Proc>]
    attr_accessor :text_filters

    # @return [Array<Proc>]
    attr_accessor :markdown_filters

    # @return [Array<Proc>]
    attr_accessor :html_filters

    # @return [Class<CommonMarker]
    attr_accessor :markdown_parser

    # @return [Cass<Nokogiri::HTML::DocumentFragment>]
    attr_accessor :html_parser

    # @return [Class<Mato::Document>]
    attr_accessor :document_factory

    # @return [Array<Symbol>] CommonMarker's parse extensions
    attr_accessor :markdown_extensions

    # @return [Array<Symbol>] CommonMarker's pars options
    attr_accessor :markdown_parse_options

    # @return [Array<Symbol>] CommonMarker's HTML rendering options
    attr_accessor :markdown_render_options

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
