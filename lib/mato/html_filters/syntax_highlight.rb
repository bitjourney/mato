# frozen_string_literal: true

# do require 'rouge' by yourself

module Mato
  module HtmlFilters
    class SyntaxHighlight
      class RougeError < StandardError
      end

      def initialize(on_rouge_error: ->(ex) { warn ex })
        @on_rouge_error = on_rouge_error
      end

      # @param [Nokogiri::HTML::DocumentFragment] doc
      def call(doc)
        doc.search("pre").each do |pre|
          if pre.at('code')
            pre.replace(highlight(pre))
          end
        end
      end

      # @param [String] language
      # @param [String] filename
      # @param [String] source
      # @return [Rouge::Lexer]
      def guess_lexer(language, filename, source)
        Rouge::Lexer.find(language)&.tap do |lexer|
          return lexer.new
        end

        Rouge::Lexer.guess(filename: filename, source: source, &:first).new
      end

      # @param [String,nil] CSS class names, e.g. "foo.js" "ruby:foo.rb"
      def parse_label(class_name)
        a = class_name&.split(/:/) || []
        if a.empty?
          {}
        elsif a.size == 1
          token = a[0].sub(/^language-/, '')
          if Rouge::Lexer.find(token)
            { language: token }
          else
            { filename: token }
          end
        else
          { language: a[0], filename: a[1] }
        end
      end

      private

      # @param [Nokogiri::XML::Element] pre a <pre/> element
      # @return [Nokogiri::XML::Element] a new <div/> wrapping the given code block
      def highlight(pre)
        code = pre.at('code')
        metadata = parse_label(code['class'])
        language = metadata[:language]&.sub(/^language-/, '')
        filename = metadata[:filename]
        source = code.inner_text

        lexer = guess_lexer(language, filename, source)

        begin
          document = Nokogiri::HTML.fragment(%{<div class="code-frame"/>})
          div = document.at('div')
          div.add_child(label_fragment(filename || language || lexer.tag)) if filename || !lexer.is_a?(Rouge::Lexers::PlainText)
          div.add_child(%{<pre class="highlight"><code data-lang="#{lexer.tag}">#{format(lexer, source)}</code></pre>})
        rescue => ex
          if ex.is_a?(RougeError) && !lexer.is_a?(Rouge::Lexers::PlainText)
            # Retry highlighting with PlainText lexer if Rouge raises an error.
            # It avoids to affect the error to whole of converting.
            lexer = Rouge::Lexers::PlainText.new
            retry
          else
            raise ex
          end
        end

        document
      end

      def label_fragment(label)
        Nokogiri::HTML.fragment(%{<div class="code-label"/>}).tap do |fragment|
          fragment.at('div').add_child(Nokogiri::XML::Text.new(label, fragment))
        end
      end

      def formatter
        @formatter ||= Rouge::Formatters::HTML.new
      end

      def format(lexer, source)
        tokens = lexer.lex(source)
        formatter.format(tokens)
      rescue => ex
        @on_rouge_error.call(ex)
        raise RougeError.new
      end
    end
  end
end
