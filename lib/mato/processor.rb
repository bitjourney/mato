# frozen_string_literal: true

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
      node = config.middlewares.reduce(input) do |content, middleware|
        middleware.call(content)
      end
      Mato::Document.new(config, node)
    end
  end
end
