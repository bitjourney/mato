# frozen_string_literal: true

require_relative './validation_error'

module Mdto
  class Config
    # @return [Array<Mdto::Middleware>]
    attr_reader :middlewares

    def initialize
      @middlewares = []
    end

    def configure(&block)
      block.call(self)

      if middlewares.empty?
        raise ValidationError, "No middleare used"
      end

      if middlewares.last.output_type < Nokogiri::XML::Node
        raise ValidationError, "The last middleware's output_type must be #{Nokogiri::XML::Node}"
      end
    end

    # @param [Class<Mdto::Middleware>] middleware
    def use(middleware)
      if middlewares.any?
        previous = middlewares.last
        if previous.output_type < middleware.input_type
          raise ValidationError, "Expected middleware.input_type to be #{previous.output_type.inspect} but got #{middleware.input_type.inspect} for #{middleware.inspect}"
        end
      end
      middlewares << (middleware.respond_to?(:call) ? middleware : middleware.new)
    end
  end
end
