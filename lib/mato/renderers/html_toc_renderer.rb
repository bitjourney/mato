# frozen_string_literal: true

require_relative '../anchor_builder'

module Mato
  module Renderers
    class HtmlTocRenderer

      H_SELECTOR = %w(h1 h2 h3 h4 h5 h6).join(',')

      def initialize(verbose: true, anchor_icon_element: AnchorBuilder::DEFAULT_ANCHOR_ICON_ELEMENT)
        @verbose = verbose
        @anchor_icon_element = anchor_icon_element
      end

      # @param [Nokogiri::XML::Node] node
      def call(node, _context = nil)
        anchor_builder = @anchor_icon_element ? AnchorBuilder.new(@anchor_icon_element) : nil
        s = +''

        stack = [0]

        node.search(H_SELECTOR).each do |hx|
          h_level = level(hx)
          if h_level > stack.last
            stack.push(h_level)
            s << %{<ul>\n}
          elsif h_level < stack.last
            while stack.last > h_level
              s << %{</li></ul>\n}
              stack.pop
            end
          end

          if anchor_builder
            s << %{<li><a href="##{anchor_builder.make_anchor_id(hx)}">#{hx.children}</a>}
          else
            s << %{<li>#{hx.children}}
          end
        end

        while stack.last != 0
          stack.pop
          s << %{</li></ul>\n}
        end
        s
      end

      private

      # @param [Nokogiri::XML::Node] node
      def level(node)
        /\d+/.match(node.name)[0].to_i
      end
    end
  end
end
