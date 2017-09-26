# frozen_string_literal: true

# core classes
require_relative "./mato/version"
require_relative "./mato/config"
require_relative "./mato/processor"
require_relative "./mato/converter"
require_relative "./mato/rescue"
require_relative "./mato/timeout"

# filter classes
require_relative "./mato/html_filters/token_link"
require_relative "./mato/html_filters/mention_link"
require_relative "./mato/html_filters/syntax_highlight"
require_relative "./mato/html_filters/task_list"
require_relative "./mato/html_filters/section_anchor"
require_relative "./mato/html_filters/sanitization"
require_relative "./mato/html_filters/bare_inline_element"

module Mato
  # @param [Proc] block
  # @yieldparam [Mato::Config] config
  # @return [Mato::Processor]
  def self.define(&block)
    config = Mato::Config.new
    config.configure(&block)
    Mato::Processor.new(config)
  end
end
