# frozen_string_literal: true

module Mato
  module Renderers
    class HtmlTocRenderer

      H_SELECTOR = %w(h1 h2 h3 h4 h5 h6).join(',')

      def initialize(verbose: true)
        @verbose = verbose
      end

      # @param [Nokogiri::XML::Node] node
      def call(node, _context = nil)
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

          s << %{<li>#{hx.children}}
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
