# frozen_string_literal: true

require_relative "./mto/version"
require_relative "./mto/config"
require_relative "./mto/processor"
require_relative "./mto/document"
require_relative "./mto/middleware"
require_relative "./mto/middlewares/common_mark"
require_relative "./mto/middlewares/to_html_node"
require_relative "./mto/middlewares/token_link"

module Mto
  def self.define(&block)
    config = Mto::Config.new
    config.configure(&block)
    Mto::Processor.new(config)
  end
end
