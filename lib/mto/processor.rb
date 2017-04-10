# frozen_string_literal: true

module Mto
  class Processor
    # @return [Mto::Config]
    attr_reader :config

    def initialize(config)
      @config = config
    end

    # @param [String] input
    # @return [Mto::Document]
    def process(input)
      node = config.middlewares.reduce(input) do |content, middleware|
        middleware.call(content)
      end
      Mto::Document.new(config, node)
    end
  end
end
