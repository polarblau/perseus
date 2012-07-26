module Perseus
  class Compiler

    def initialize(root)
      @root = root
    end

    def compile
      @root.to_html
    end

  end
end
