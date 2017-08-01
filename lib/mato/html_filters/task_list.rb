# frozen_string_literal: true

module Mato
  module HtmlFilters
    class TaskList
      CHECKED_MARK = "[x] "
      UNCHECKED_MARK = "[ ] "

      DEFAULT_TASK_LIST_CLASS = "task-list-item"
      DEFAULT_CHECKBOX_CLASS = "task-list-item-checkbox"

      def initialize(task_list_class: DEFAULT_TASK_LIST_CLASS, checkbox_class: DEFAULT_CHECKBOX_CLASS)
        @task_list_class = task_list_class
        @checkbox_class = checkbox_class
      end

      # @param [Nokogiri::HTML::DocumentFragment] doc
      def call(doc)
        doc.search("li").each do |li|
          weave(li)
        end
      end

      # @param [Nokogiri::XML::Node] li
      def weave(li)
        text_node = li.xpath('.//text()').first
        checked = has_checked_mark?(text_node)
        unchecked = has_unchecked_mark?(text_node)

        return unless checked || unchecked

        li["class"] = @task_list_class

        text_node.content = trim_mark(text_node.content, checked)
        checkbox = build_checkbox_node(checked)
        text_node.add_previous_sibling(checkbox)
      end

      def has_checked_mark?(text_node)
        text_node&.content&.start_with?(CHECKED_MARK)
      end

      def has_unchecked_mark?(text_node)
        text_node&.content&.start_with?(UNCHECKED_MARK)
      end

      def trim_mark(content, checked)
        if checked
          content.sub(CHECKED_MARK, '')
        else
          content.sub(UNCHECKED_MARK, '')
        end
      end

      def build_checkbox_node(checked)
        Nokogiri::HTML.fragment('<input type="checkbox"/>').tap do |fragment|
          checkbox = fragment.children.first
          checkbox["class"] = @checkbox_class
          checkbox["disabled"] = 'disabled'
          checkbox["checked"] = 'checked' if checked
        end
      end
    end
  end
end
