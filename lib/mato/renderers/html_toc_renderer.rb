# frozen_string_literal: true

require_relative '../anchor_builder'

module Mato
  module Renderers
    class HtmlTocRenderer

      H_SELECTOR = %w(h1 h2 h3 h4 h5 h6).join(',')
      ANCHOR_SELECTOR = "a.#{AnchorBuilder::CSS_CLASS_NAME}"

      # @param [Nokogiri::HTML::DocumentFragment] doc
      # @return [String]
      def call(doc)
        s = +''

        stack = [0]

        doc.css(H_SELECTOR).each do |hx|
          h_level = level(hx)

          if h_level > stack.last
            stack.push(h_level)
            s << %{<ul>\n}
          elsif h_level < stack.last
            while h_level < stack.last
              # keep the user-level stack top element (i.e. [0, #]) here
              if stack.size <= 2
                s << %{</li>\n}
                stack.pop
                stack.push(h_level)
                break
              else
                s << %{</li></ul>\n}
                stack.pop
              end
            end
          else
            s << %{</li>\n}
          end

          node = hx.dup

          anchor = node.css(ANCHOR_SELECTOR).first

          s << %{<li>}
          if anchor
            s << %{<a href="##{anchor['id']}">}
            anchor.unlink
          end

          node.css('a').each do |a|
            a.replace(a.children)
          end
          s << node.children.to_html(save_with: 0)

          if anchor
            s << %{</a>}
          end
        end

        # roll up all the stack elements
        while stack.last != 0
          stack.pop
          s << %{</li></ul>\n}
        end

        s
      end

      private

      # @param [Nokogiri::XML::Node] node
      # @return [Integer] 1 to 6
      def level(node)
        /\d+/.match(node.name)[0].to_i
      end
    end
  end
end
