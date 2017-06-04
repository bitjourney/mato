# frozen_string_literal: true

# core classes
require_relative "./mato/version"
require_relative "./mato/config"
require_relative "./mato/processor"

# filter classes
require_relative "./mato/html_filters/token_link"

module Mato
  # @param [Proc] block
  # @yieldparam [Mato::Config] config
  def self.define(&block)
    config = Mato::Config.new
    config.configure(&block)
    Mato::Processor.new(config)
  end
end
