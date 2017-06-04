# frozen_string_literal: true

module Mato
  class Context
    attr_reader :config
    attr_reader :data

    def initialize(config)
      @config = config
      @data = {}
    end
  end
end
