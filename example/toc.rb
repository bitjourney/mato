# frozen_string_literal: true

require 'mato'

mato = Mato.define do |_config|
end

puts mato.process(<<~'MARKDOWN').render_html_toc
  # **First** Level Title

  ## **Second** Level Title

  ### **Third** Level Title

  ##### **Fifth** Level Title

  # **First** Level Title Again
MARKDOWN
