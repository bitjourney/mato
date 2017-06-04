module Mato
  module Concerns
    module HtmlNodeCheckable
      module_function

      # @param [Nokogiri::XML::Node] node
      # @param [Array<String>] tags - set of tags
      # @return [Boolean] true if the node has the specified tags as a parent
      def has_ancestor?(node, *tags)
        current = node
        while (current = current.parent)
          if tags.include?(current.name)
            return true
          end
        end
        false
      end
    end
  end
end
