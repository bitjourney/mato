# frozen_string_literal: true

require 'erb'

module Mato
  class AnchorBuilder

    # assumes use of font-awesome
    # specify it as "<span aria-hidden=\"true\" class=\"octicon octicon-link\"></span>" if you use octicon
    DEFAULT_ANCHOR_ICON_ELEMENT = %q{<i class="fa fa-link"></i>}

    attr_reader :anchor_icon_element
    attr_reader :context

    def initialize(anchor_icon_element = DEFAULT_ANCHOR_ICON_ELEMENT)
      @anchor_icon_element = anchor_icon_element
      @id_map = {}
    end

    # @param [Nokogiri::XML::Node] hx
    def make_anchor_element(hx)
      id = make_anchor_id(hx)
      %{<a id="#{id}" href="##{id}" aria-hidden="true">#{anchor_icon_element}</a>}
    end

    def make_anchor_id(hx)
      prefix = make_anchor_id_prefix(hx.inner_text)
      "#{prefix}#{make_anchor_id_suffix(prefix)}"
    end

    private

    def make_anchor_id_suffix(text)
      @id_map[text] ||= -1
      unique_id = @id_map[text] += 1

      if unique_id > 0
        "-#{unique_id}"
      else
        ""
      end
    end

    def make_anchor_id_prefix(text)
      ERB::Util.url_encode(text.downcase.gsub(/[^\p{Word}\- ]/u, "").tr(" ", "-"))
    end
  end
end
