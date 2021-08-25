# frozen_string_literal: true

require_relative '../test_helper'

require 'rouge'

class SyntaxHighlightTest < FilterTest
  def subject
    @subject ||= Mato::HtmlFilters::SyntaxHighlight.new
  end

  def highlight(markdown)
    process(markdown).render_html
  end

  def test_guess_lexer
    assert { subject.guess_lexer('js', nil, '').tag == 'javascript' }
    assert { subject.guess_lexer(nil, 'foo.js', '').tag == 'javascript' }
    assert { subject.guess_lexer(nil, nil, %{#!/usr/bin/env node\n}).tag == 'javascript' }
    assert { subject.guess_lexer('diff', 'config.yml', '').tag == 'diff' }
  end

  def test_guess_lexer_for_ambiguous_filename
    # .pl is perl or prolog
    assert do
      tag = subject.guess_lexer(nil, 'foo.pl', '').tag
      tag == "perl" || tag == "prolog"
    end
  end

  def test_guess_lexer_for_unknown_file
    assert { subject.guess_lexer(nil, 'unknown', '').tag == 'plaintext' }
  end

  def test_parse_label
    assert { subject.parse_label(nil) == {} }
    assert { subject.parse_label('ruby:foo.rb') == { language: 'ruby', filename: 'foo.rb' } }
    assert { subject.parse_label('ruby') == { language: 'ruby' } }
    assert { subject.parse_label('foo.rb') == { filename: 'foo.rb' } }
    assert { subject.parse_label('Gemfile') == { filename: 'Gemfile' } }
  end

  def test_call_with_lang
    markdown = <<~'MD'
      ```ruby
      p "Hello, world!"
      ````
    MD

    assert_html_eq(highlight(markdown), <<~'HTML')
      <div class="code-frame">
      <div class="code-label">ruby</div>
      <pre class="highlight"><code data-lang="ruby"><span class="nb">p</span> <span class="s2">"Hello, world!"</span>
      </code></pre>
      </div>
    HTML
  end

  def test_call_with_filename
    markdown = <<~'MD'
      ```foo.rb
      p "Hello, world!"
      ````
    MD

    assert_html_eq(highlight(markdown), <<~'HTML')
      <div class="code-frame">
      <div class="code-label">foo.rb</div>
      <pre class="highlight"><code data-lang="ruby"><span class="nb">p</span> <span class="s2">"Hello, world!"</span>
      </code></pre>
      </div>
    HTML
  end

  def test_call_with_lang_filname_pair
    markdown = <<~'MD'
      ```ruby:foo.rb
      p "Hello, world!"
      ````
    MD

    assert_html_eq(highlight(markdown), <<~'HTML')
      <div class="code-frame">
      <div class="code-label">foo.rb</div>
      <pre class="highlight"><code data-lang="ruby"><span class="nb">p</span> <span class="s2">"Hello, world!"</span>
      </code></pre>
      </div>
    HTML
  end

  def test_guess_language
    markdown = <<~'MD'
      ```
      #!/usr/bin/env ruby
      p "Hello, world!"
      ````
    MD

    assert_html_eq(highlight(markdown), <<~'HTML')
      <div class="code-frame">
      <div class="code-label">ruby</div>
      <pre class="highlight"><code data-lang="ruby"><span class="c1">#!/usr/bin/env ruby</span>
      <span class="nb">p</span> <span class="s2">"Hello, world!"</span>
      </code></pre>
      </div>
    HTML
  end

  def test_call_with_lang_filname_pair_with_diferent_attrs
    markdown = <<~'MD'
      ```diff:foo.rb
      - p "Hello, world!"
      + puts "Hello, world!"
      ````
    MD

    assert_html_eq(highlight(markdown), <<~'HTML')
      <div class="code-frame">
      <div class="code-label">foo.rb</div>
      <pre class="highlight"><code data-lang="diff"><span class="gd">- p "Hello, world!"
      </span><span class="gi">+ puts "Hello, world!"
      </span></code></pre>
      </div>
    HTML
  end

  def test_call_with_rouge_error
    markdown = <<~'MD'
      ```ruby
      puts "hello"
      ```
    MD

    any_instance_of(Rouge::Lexers::Ruby) do |klass|
      stub(klass).lex { raise "Error!" }
    end

    begin
      stderr = StringIO.new
      $stderr = stderr
      got = highlight(markdown)
    ensure
      $stderr = STDERR
    end

    assert_html_eq(got, <<~'HTML')
      <div class="code-frame"><pre class="highlight"><code data-lang="plaintext">puts "hello"
      </code></pre></div>
    HTML

    assert_equal "Error!\n", stderr.string

    # Remove injected any_instance_of double for Rouge::Lexers::Ruby
    RR::Injections::DoubleInjection.reset
  end
end
