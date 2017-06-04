# frozen_string_literal: true

require_relative('./context')
require_relative('./document')


module Mato
  class Processor
    # @return [Mato::Config]
    attr_reader :config

    def initialize(config)
      @config = config
    end

    # @param [String] input
    # @return [Mato::Document]
    def process(input)
      text = input.dup
      context = config.context_factory.new(config)

      config.text_filters.each do |filter|
        filter.call(text, context)
      end

      markdown_node = config.markdown_processor.call(text, context)

      config.markdown_filters.each do |filter|
        filter.call(markdown_node, context)
      end

      html_node = config.html_processor.call(markdown_node, context)

      config.html_filters.each do |filter|
        filter.call(html_node, context)
      end

      config.document_factory.new(html_node, context)
    end
  end
end
