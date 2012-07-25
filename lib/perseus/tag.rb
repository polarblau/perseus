module Perseus
  class Tag

    SELF_CLOSING_TAGS = %w(img br hr)

    # selector must be an instance of Perseus::Selector
    def initialize(selector)
      @selector = selector
    end

    def render
      html = "<#{name}#{attributes}"
      if self_closing?
        html << " />\n"
        # TODO: check for children and throw execption?
      else
        if @selector.children.any?
          html << ">\n"
          html << @selector.children.map(&:to_html).join('\n')
        else
          html << ">"
          # TODO: content
        end
        html << "</#{name}>\n"
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

  end
end