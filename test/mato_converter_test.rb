# frozen_string_literal: true

require_relative './test_helper'

class MatoConverterTest < MyTest
  def mato
    @mato ||= Mato.define do |_config|
    end
  end

  def patterns # rubocop:disable Metrics/MethodLength
    [
      ['#Hello, world!', '# Hello, world!'],
      ['##Hello, world!', '## Hello, world!'],
      ["##Hello, world!\n\n", "## Hello, world!\n\n"],
      ['> #Hello, world!', '> #Hello, world!'],
      [
        <<~'MD',
          ```
          #foo
          ```
          #bar
            MD

        <<~'MD',
          ```
          #foo
          ```
          # bar
            MD
      ],
      [
        <<~'MD',
          * #foo
           * #bar
            MD

        <<~'MD',
          * #foo
           * #bar
            MD
      ],
      [
        <<~'MD',
          <p>#foo</p>
          MD

        <<~'MD',
          <p>#foo</p>
          MD
      ],
      [
        <<~'MD',
          #foo
          ##bar
          #baz
          yey!
            MD

        <<~'MD',
          # foo
          ## bar
          # baz
          yey!
            MD
      ],
      [
        <<-'MD', # keep indent in contents
              #foo
              ##bar
              #baz
              yey!
            MD

        <<-'MD', # keep indent in contents
              #foo
              ##bar
              #baz
              yey!
            MD
      ],
      [
        <<~'MD',
          #foo *#bar* #baz
          MD

        <<~'MD',
          # foo *#bar* #baz
          MD
      ],
    ]
  end

  def test_convert
    patterns.each do |input, output|
      assert { mato.convert(input, flavor: :redcarpet) == output }
    end
  end
end
