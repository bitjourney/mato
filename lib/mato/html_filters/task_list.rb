# frozen_string_literal: true

module Mato
  module HtmlFilters
    class TaskList
      CHECKED_MARK = /\A\[x\] /
      UNCHECKED_MARK = /\A\[ \] /
      CHECKED_MARK_FOR_EMPTY_TASK_LIST = /\A\[x\] ?/
      UNCHECKED_MARK_FOR_EMPTY_TASK_LIST = /\A\[ \] ?/

      DEFAULT_TASK_LIST_CLASS = "task-list-item"
      DEFAULT_CHECKBOX_CLASS = "task-list-item-checkbox"

      def initialize(task_list_class: DEFAULT_TASK_LIST_CLASS, checkbox_class: DEFAULT_CHECKBOX_CLASS, convert_empty_task_list: false)
        @task_list_class = task_list_class
        @checkbox_class = checkbox_class
        @convert_empty_task_list = convert_empty_task_list
      end

      # @param [Nokogiri::HTML4::DocumentFragment] doc
      def call(doc)
        doc.search("li").each do |li|
          weave(li)
        end
      end

      # @param [Nokogiri::XML::Node] li
      def weave(li)
        text_node = li.xpath('./p[1]/text()').first || li.xpath('.//text()').first
        checked = has_checked_mark?(text_node)
        unchecked = has_unchecked_mark?(text_node)

        return unless checked || unchecked

        li["class"] = @task_list_class

        text_node.content = trim_mark(text_node.content, checked)
        checkbox = build_checkbox_node(checked)
        text_node.add_previous_sibling(checkbox)
      end

      def has_checked_mark?(text_node)
        text_node&.content&.match?(checked_mark)
      end

      def has_unchecked_mark?(text_node)
        text_node&.content&.match?(unchecked_mark)
      end

      def trim_mark(content, checked)
        if checked
          content.sub(checked_mark, '')
        else
          content.sub(unchecked_mark, '')
        end
      end

      def checked_mark
        if @convert_empty_task_list
          CHECKED_MARK_FOR_EMPTY_TASK_LIST
        else
          CHECKED_MARK
        end
      end

      def unchecked_mark
        if @convert_empty_task_list
          UNCHECKED_MARK_FOR_EMPTY_TASK_LIST
        else
          UNCHECKED_MARK
        end
      end

      def build_checkbox_node(checked)
        Nokogiri::HTML4.fragment('<input type="checkbox"/>').tap do |fragment|
          checkbox = fragment.children.first
          checkbox["class"] = @checkbox_class
          checkbox["disabled"] = 'disabled'
          checkbox["checked"] = 'checked' if checked
        end
      end
    end
  end
end
