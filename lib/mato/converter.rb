# frozen_string_literal: true

require 'set'

# Convert X-flavored markdown to CommonMark
module Mato
  class Converter

    FLAVORES = Set.new([
                         :redcarpet, # legacy GFM uses it
                       ]).freeze

    attr_reader :processor
    attr_reader :content
    attr_reader :flavor

    # @return [Array<String>]
    attr_reader :content_lines

    def initialize(processor, content, flavor)
      unless FLAVORES.include?(flavor)
        raise "Unsupported flavor #{flavor.inspect}, it must be one of: #{FLAVORES.map(&:inspect).join(' ')}"
      end

      @processor = processor
      @content = content
      @content_lines = content.split(/\n/)
      @flavor = flavor
    end

    def run
      # @type [Markly::Node]
      document = processor.parse_markdown(content)

      convert_headings!(document)

      content_lines.join("\n").tap do |c|
        # fixup newlines removed by String#split
        content.scan(/\n+\z/) do |matched|
          c << matched
        end
      end
    end

    def convert_headings!(document)
      document.walk.select do |node|
        node.type == :text &&
          node.source_position[:start_column] == 1 &&
          node.parent.type == :paragraph &&
          node.parent.parent.type == :document
      end.reverse_each do |node|
        replacement = node.string_content.gsub(/\A(#+)(?=\S)/, '\1 ')

        if node.string_content != replacement
          pos = node.source_position
          content_lines[pos[:start_line] - 1][(pos[:start_column] - 1)...pos[:end_column]] = replacement
        end
      end
    end
  end
end
