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
end
