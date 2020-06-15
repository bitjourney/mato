# frozen_string_literal: true

require_relative '../test_helper'

class TaskListTest < FilterTest
  def subject
    Mato::HtmlFilters::TaskList.new
  end

  def test_simple
    input = <<~'MARKDOWN'
      * [ ] foo
      * [x] bar
      * baz
    MARKDOWN

    output = <<~'HTML'
      <ul>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" disabled>foo</li>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" disabled checked>bar</li>
      <li>baz</li>
      </ul>
    HTML

    assert_html_eq(mato.process(input).render_html, output)
  end

  def test_empty_task_list
    # NOTE: The following markdown has trailing spaces on purpose.
    #       Do NOT remove them!
    input = <<~'MARKDOWN'
      * [ ]
      * [x]
      * [ ] 
      * [x] 
    MARKDOWN

    output = <<~'HTML'
      <ul>
      <li>[ ]</li>
      <li>[x]</li>
      <li>[ ]</li>
      <li>[x]</li>
      </ul>
    HTML

    assert_html_eq(mato.process(input).render_html, output)
  end
end

class TaskListEnableConvertEmptyTaskListOptionTest < FilterTest
  def subject
    Mato::HtmlFilters::TaskList.new(convert_empty_task_list: true)
  end

  def test_simple
    input = <<~'MARKDOWN'
      * [ ] foo
      * [x] bar
      * baz
    MARKDOWN

    output = <<~'HTML'
      <ul>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" disabled>foo</li>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" disabled checked>bar</li>
      <li>baz</li>
      </ul>
    HTML

    assert_html_eq(mato.process(input).render_html, output)
  end

  def test_empty_task_list
    # NOTE: The following markdown has trailing spaces on purpose.
    #       Do NOT remove them!
    input = <<~'MARKDOWN'
      * [ ]
      * [x]
      * [ ] 
      * [x] 
    MARKDOWN

    output = <<~'HTML'
      <ul>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" disabled></li>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" disabled checked></li>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" disabled></li>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" disabled checked></li>
      </ul>
    HTML

    assert_html_eq(mato.process(input).render_html, output)
  end
end
