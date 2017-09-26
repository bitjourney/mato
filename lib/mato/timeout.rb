# frozen_string_literal: true

require 'timeout'

module Mato
  class Timeout
    attr_reader :filter
    attr_reader :duration_sec
    attr_reader :on_timeout

    def initialize(filter, timeout:, on_timeout:)
      @filter = filter
      @duration_sec = timeout
      @on_timeout = on_timeout

      unless on_timeout
        raise ArgumentError, "Missing on_timeout callback"
      end
    end

    def call(content)
      ::Timeout.timeout(duration_sec) do
        filter.call(content)
      end
    rescue ::Timeout::Error => e
      on_timeout.call(e)
      content
    end
  end
end
