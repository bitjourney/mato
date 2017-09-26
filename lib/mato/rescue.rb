# frozen_string_literal: true

module Mato
  class Rescue
    attr_reader :filter
    attr_reader :on_error

    def initialize(filter, on_error:)
      @filter = filter
      @on_error = on_error
    end

    def call(content)
      filter.call(content)
    rescue => e
      on_error.call(e)
      content
    end
  end
end
