module Perseus
  class Tag

    SELF_CLOSING_TAGS = %w(img br hr)

    # selector must be an instance of Perseus::Selector
    def initialize(selector)
      @selector = selector
    end

    def render(level = 0)
      html = "#{indent(level)}<#{name}#{attributes}"
      if self_closing?
        html << " />\n"
        # TODO: check for children and throw execption if any?
      else
        if @selector.children.any?
          html << ">\n"
          html << @selector.children.map {|c| c.to_html(level + 1) }.join("\n")
          html << "#{indent(level)}</#{name}>\n"
        else
          html << ">"
          # TODO: content
          html << "</#{name}>\n"
        end
      end
      html
    end

    def self_closing?
      SELF_CLOSING_TAGS.include? name
    end

    def name
      @selector.tag
    end

    def attributes
      @selector.attributes.inject('') {|m, p| m << " #{p[0]}=\"#{p[1]}\""}
    end

  private

    def indent(level)
      "  " * level
    end

  end
end
