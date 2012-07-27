module Perseus
  class Compiler

    def initialize(root_selectors)
      @root_selectors = root_selectors
    end

    def compile
      @root_selectors.map(&:to_html).join("\n")
    end

  end
end
