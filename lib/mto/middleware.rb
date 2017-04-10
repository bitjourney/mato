# frozen_string_literal: true

module Mto
  module Middleware
    def self.included(target)
      target.instance_eval do
        # @param [Class] type
        def input(type)
          @input_type = type
        end

        def input_type
          @input_type
        end

        # @param [Class] type
        def output(type)
          @output_type = type
        end

        def output_type
          @output_type
        end
      end
    end

    def input_type
      self.class.input_type
    end

    def output_type
      self.class.output_type
    end
  end
end
