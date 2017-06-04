# frozen_string_literal: true

require_relative '../test_helper'

class SyntaxHighlightTest < Minitest::Test
  def subject
    @subject ||= Mato::HtmlFilters::SyntaxHighlight.new
  end

  def highlight(markdown)
    mato = Mato.define do |config|
      config.append_html_filter(subject)
    end
    mato.process(markdown).render_html
  end

  def test_guess_lexer
    assert { subject.guess_lexer('js', nil, '').tag == 'javascript' }
    assert { subject.guess_lexer(nil, 'foo.js', '').tag == 'javascript' }
    assert { subject.guess_lexer(nil, nil, %{#!/usr/bin/env node\n}).tag == 'javascript' }
  end

  def test_parse_label
    assert { subject.parse_label(nil) == {} }
    assert { subject.parse_label('ruby:foo.rb') == { language: 'ruby', filename: 'foo.rb' } }
    assert { subject.parse_label('ruby') == { language: 'ruby' } }
    assert { subject.parse_label('foo.rb') == { filename: 'foo.rb' } }
    assert { subject.parse_label('Gemfile') == { filename: 'Gemfile' } }
  end

  def test_call
    markdown = <<~'MD'
      ```ruby
      p "Hello, world!"
      ````
    MD

    assert_html_eq(highlight(markdown), <<~'HTML')
      <div class="code-frame">
      <div class="code-label">language-ruby</div>
      <pre class="highlight"><code data-lang="plaintext">p "Hello, world!"
      </code></pre>
      </div>
    HTML
  end
end
