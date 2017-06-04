# frozen_string_literal: true

# CommonMarker, a Ruby interface to cmark-gfm (https://github.com/github/cmark)
require 'commonmarker'

module Mato
  class MarkdownProcessor
    attr_reader :extensions, :options

    # see https://github.com/github/cmark/tree/master/extensions
    def initialize(table: true, strikethrough: true, autolink: true, tagmiddleware: false, options: [:DEFAULT])
      @extensions = []
      @extensions << :table if table
      @extensions << :strikethrough if strikethrough
      @extensions << :autolink if autolink
      @extensions << :tagmiddleware if tagmiddleware
      @options = options
    end

    # @param [String] content
    # @return [CommonMarker::Node]
    def call(content, _context = nil)
      CommonMarker.render_doc(content, options, extensions)
    end
  end
end
