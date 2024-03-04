# frozen_string_literal: true

require_relative('./document')

require 'nokogiri'
require 'commonmarker'

module Mato
  class Processor
    # @return [Mato::Config]
    attr_reader :config

    def initialize(config)
      @config = config
      config.markdown_parse_options.each do |options|
        @flags = @flags ? @flags | options : options
      end
    end

    # @param [String] input
    # @return [Mato::Document]
    def process(input)
      text = input.dup

      config.text_filters.each do |filter|
        # A text filter returns a mutated text
        text = filter.call(text)
      end

      markdown_node = parse_markdown(text)

      config.markdown_filters.each do |filter|
        # A markdown filter mutates the argument
        filter.call(markdown_node)
      end

      html = render_to_html(markdown_node)
      doc = parse_html(html)

      config.html_filters.each do |filter|
        # An HTML filter mutates the argument
        filter.call(doc)
      end

      config.document_factory.new(doc.freeze)
    end

    # @param [String] text
    # @return [Markly::Node]
    def parse_markdown(text)
      config.markdown_parser.parse(text, flags: @flags, extensions: config.markdown_extensions)
    end

    # @param [Markly::Node] markdown_node
    # @return [String]
    def render_to_html(markdown_node)
      markdown_node.to_html(flags: @flags)
    end

    # @param [String] html
    # @return [Nokogiri::HTML4::DocumentFragment]
    def parse_html(html)
      config.html_parser.parse(html)
    end

    def convert(content, flavor:)
      Mato::Converter.new(self, content, flavor).run
    end
  end
end
