# frozen_string_literal: true

# Wraps CommonMark's HTML blocks with <p/>.
#
# See Also:
# http://spec.commonmark.org/0.28/#html-blocks
# https://github.com/commonmark/CommonMark/issues/492
module Mato
  module HtmlFilters
    class BareInlineElement
      STANDALONE_INLINE_ELEMENTS = Set.new([
                                             "img",
                                             "input",
                                             "textarea",
                                           ])

      def call(doc)
        doc.children.each do |node|
          next unless STANDALONE_INLINE_ELEMENTS.include?(node.name)

          parent = Nokogiri::HTML4.fragment('<p/>')
          parent.child.add_child(node.dup)
          node.replace(parent)
        end
      end
    end
  end
end
