module Perseus
  class Selector

    attr_accessor :children, :text

    def initialize(text)
      @text     = text
      @children = []
    end

    def to_s
      @text
    end

  end
end
