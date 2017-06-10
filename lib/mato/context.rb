# frozen_string_literal: true

module Mato
  class Context
    attr_reader :config

    def initialize(config = Mato::Config.new)
      @config = config
      @data = {}
    end

    def get_data_for(instance)
      @data[instance] ||= {}
    end

    def make_unique_id_for(instance)
      data = get_data_for(instance)
      data[:unique_id] = (data[:unique_id] || 0) + 1
    end
  end
end
