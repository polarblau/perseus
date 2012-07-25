module Perseus
  class Selector

    CLASS_IDENTIFIER  = '.'
    ID_IDENTIFIER     = '#'
    VALID_CLASS_NAMES = /\.(-?[_a-zA-Z]+[\w-]*)/
    VALID_ID_NAME     = /#(-?[_a-zA-Z]+[\w-]*)/
    INLINE_ATTRIBUTES = /\[([\w-]*)\=([\w-]*)\]/
    DEFAULT_TAG       = 'div'

    attr_accessor :children, :text

    def initialize(text)
      @text     = text
      @children = []
    end

    def to_html
      Perseus::Tag.new(self).render
    end

    def id
      @text.scan(VALID_ID_NAME).flatten.first
    end

    def classes
      @text.scan(VALID_CLASS_NAMES).flatten
    end

    def has_id?
      !id.nil?
    end

    def has_classes?
      !classes.empty?
    end

    def inline_attributes
      attrs = @text.scan(INLINE_ATTRIBUTES).flatten
      Hash[*attrs]
    end

    def attributes
      # TODO: merge in attributes from options (doc comments)
      # TODO: merge in attributes defined in selector via [a=b]
      attrs          = inline_attributes
      attrs['id']    = id if has_id?
      attrs['class'] = classes.join(' ') if has_classes?
      attrs
    end

    def tag
      # does the selector start with a class or id identifier?
      if [CLASS_IDENTIFIER, CLASS_IDENTIFIER].include? @text[0]
        DEFAULT_TAG
      elsif @text.include? CLASS_IDENTIFIER
        @text.split(CLASS_IDENTIFIER).first
      elsif @text.include? ID_IDENTIFIER
        @text.split(ID_IDENTIFIER).first
      else
        DEFAULT_TAG
      end
    end

  end
end
