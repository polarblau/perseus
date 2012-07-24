require 'sass'

module Perseus

  class Engine

    def initialize(styles)
      sass_engine = Sass::Engine.new(styles, syntax: :sass)
      @tree = sass_engine.to_tree
    end

    def compile(node = @tree.children.first)
      if node.children.empty?
        compile_tag(node.rule)
      else
        compile_tag(node.rule) do
          node.children.each {|c| compile(c) } unless node.children.empty?
        end
      end
    end

    def compile_tag(rule, &block)

    end

    def tag_type(selector)

    end

    def extract_attributes(selector)

    end

  end

end
