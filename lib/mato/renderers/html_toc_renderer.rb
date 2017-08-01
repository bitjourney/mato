# frozen_string_literal: true

require_relative '../anchor_builder'

module Mato
  module Renderers
    class HtmlTocRenderer

      H_SELECTOR = %w(h1 h2 h3 h4 h5 h6).join(',')

      # @param [Nokogiri::XML::Node] node
      def call(node)
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

          first_child = hx.child
          if first_child.name == 'a' && first_child['class'] == AnchorBuilder::CSS_CLASS_NAME
            s << %{<li><a href="##{first_child['id']}">}

            child = first_child.next_sibling
            while child
              s << child.to_html
              child = child.next_sibling
            end

            s << %{</a>}
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
