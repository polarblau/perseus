require 'sass'

module Perseus
  class Parser

    # '>' => :child,
    # '~' => :sibling,
    # '+' => :brother,
    # ',' => :new_selector

    def initialize(styles)
      # TODO: options, syntax
      @tree = Sass::Engine.new(styles, :syntax => :sass).to_tree
      @options_buffer = {}
    end

    # TODO: ensure that the first rule is of the correct type
    # TODO: deal with child, sibling and brother selectors
    # TODO: deal with new selector, starting with comma
    # TODO: deal with groups
    # TODO: deal with option comments
    def parse
      root_nodes      = @tree.children.dup
      root_selectors  = []

      until root_nodes.empty?
        if (node = root_nodes.shift).is_a? Sass::Tree::CommentNode
          extract_options_from_comment(node)
        else
          root_selectors << parse_node(node)
        end
      end

      root_selectors
    end

    def parse_node(node, parent = nil)

      if node.is_a? Sass::Tree::CommentNode
        extract_options_from_comment(node)
        return
      end

      child_nodes = node.children.select {|c|
        [Sass::Tree::RuleNode, Sass::Tree::CommentNode].include? c.class }
      selectors   = node.rule.first.split

      parent    ||= Perseus::Selector.new(selectors.shift, @options_buffer.flush!)
      root        = parent

      selectors.each_with_index do |selector, index|
        parent.children << Perseus::Selector.new(selector, @options_buffer.flush!)
        parent = parent.children.last if index == selectors.size - 1
      end

      parse_node(child_nodes.shift, parent) until child_nodes.empty?

      root
    end

    def extract_options_from_comment(node)
      node.value.first.split("\n").each do |line|
        key, value = line.scan(/@([\w-]*):(.*)/).flatten
        @options_buffer[key] = value.strip
      end
    end

  end
end
