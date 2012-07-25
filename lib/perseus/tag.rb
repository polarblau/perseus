module Perseus
  class Tag

    # selector must be an instance of Perseus::Selector
    def initialize(selector)
      @selector = selector
    end

    def render
      ''
    end

  end
end
