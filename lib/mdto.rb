# frozen_string_literal: true

require_relative "./mdto/version"
require_relative "./mdto/config"
require_relative "./mdto/processor"
require_relative "./mdto/document"
require_relative "./mdto/middleware"
require_relative "./mdto/middlewares/common_mark"
require_relative "./mdto/middlewares/to_html_node"
require_relative "./mdto/middlewares/token_link"

module Mdto
  def self.define(&block)
    config = Mdto::Config.new
    config.configure(&block)
    Mdto::Processor.new(config)
  end
end
