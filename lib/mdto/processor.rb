# frozen_string_literal: true

module Mdto
  class Processor
    # @return [Mdto::Config]
    attr_reader :config

    def initialize(config)
      @config = config
    end

    # @param [String] input
    # @return [Mdto::Document]
    def process(input)
      node = config.middlewares.reduce(input) do |content, middleware|
        middleware.call(content)
      end
      Mdto::Document.new(config, node)
    end
  end
end
