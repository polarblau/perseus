module Perseus
  class Selector

    VALID_CLASS_NAME = '-?[_a-zA-Z]+[_a-zA-Z0-9-]*'

    attr_accessor :children, :text

    def initialize(text)
      @text     = text
      @children = []
    end

    def to_html
      # TODO: tag class?
      "<div#{attributes}></div>"
    end

    def id
      @text.scan(/\#(#{VALID_CLASS_NAME})/).flatten.first
    end

    def classes
      @text.scan(/\.(#{VALID_CLASS_NAME})/).flatten
    end

    def has_id?
      !id.nil?
    end

    def has_classes?
      !classes.empty?
    end

  private

    def attributes
      attrs, attrs_s = {}, ''
      attrs[:id]    = id if has_id?
      attrs[:class] = classes.join if has_classes?
      attrs.each {|k, v| attrs_s << "#{k}=\"#{v}\"" }
      attrs_s = ' ' + attrs_s unless attrs_s.empty?
      attrs_s
    end

  end
end
