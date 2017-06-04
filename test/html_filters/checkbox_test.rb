# frozen_string_literal: true

require_relative '../test_helper'

class CheckboxTest < Minitest::Test
  def mato
    @mato ||= Mato.define do |config|
      config.append_html_filter(Mato::HtmlFilters::Checkbox.new)
    end
  end

  def test_simle
    assert do
      input = <<~'HTML'
        * [ ] foo
        * [x] bar
        * baz
        *
      HTML

      output = <<~'HTML'
        <ul>
        <li class="task-list-item">
        <input type="checkbox" class="task-list-item-checkbox" disabled>foo</li>
        <li class="task-list-item">
        <input type="checkbox" class="task-list-item-checkbox" disabled checked>bar</li>
        <li>baz</li>
        <li>
        </ul>
      HTML

      mato.process(input).render_html == output
    end
  end
end
