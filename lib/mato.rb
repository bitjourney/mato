# frozen_string_literal: true

require_relative "./mato/version"
require_relative "./mato/config"
require_relative "./mato/processor"
require_relative "./mato/document"
require_relative "./mato/middleware"
require_relative "./mato/middlewares/common_mark"
require_relative "./mato/middlewares/to_html_node"
require_relative "./mato/middlewares/token_link"

module Mato
  def self.define(&block)
    config = Mato::Config.new
    config.configure(&block)
    Mato::Processor.new(config)
  end
end
