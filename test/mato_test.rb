# frozen_string_literal: true

require_relative './test_helper'

class MatoTest < MyTest
  def mato
    @mato ||= Mato.define do |_config|
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::Mato::VERSION
  end

  def test_it_does_something_useful
    assert do
      mato.process('Hello, world!').render_html == "<p>Hello, world!</p>\n"
    end
  end

  def test_empty
    assert do
      Mato::Document.empty.render_html == ''
    end
  end

  def test_document_is_serializable
    assert do
      Marshal.load(Marshal.dump(mato.process('Hello, world!'))).render_html == "<p>Hello, world!</p>\n"
    end
  end

  def test_apply_html_filters
    doc = mato.process('Hello, world!')
    new_doc = doc.apply_html_filters(->(node) { node.child.replace("<p>Hi!</p>") })

    assert do
      doc.render_html == "<p>Hello, world!</p>\n"
    end

    assert do
      new_doc.render_html == "<p>Hi!</p>\n"
    end
  end

  def test_footnotes
    doc = mato.process(<<~MARKDOWN)
      This is some text.[^1]. Other text.[^footnote].

      [^other-note]:  Hi!

      [^1]: Some *bolded* footnote definition.
    MARKDOWN

    assert do
      doc.render_html == <<~'HTML'
        <p>This is some text.<sup class="footnote-ref"><a href="#fn1" id="fnref1">[1]</a></sup>. Other text.[^footnote].</p>
        <section class="footnotes">
        <ol>
        <li id="fn1">
        <p>Some <em>bolded</em> footnote definition. <a href="#fnref1" class="footnote-backref">↩</a></p>
        </li>
        </ol>
        </section>
      HTML
    end
  end
end
