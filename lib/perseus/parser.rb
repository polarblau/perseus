module Perseus
  class Parser


#   SWITCHES = {
#      '#' => :id,
#      '.' => :class,
#      '[' => :attribute,
#      ':' => :pseudo,
#      '>' => :child,
#      '~' => :sibling,
#      '+' => :brother,
#      ' ' => :descendant,
#      ',' => :new_selector
#    }

    def initialize(styles)
      # TODO: accept file for styles (detect syntax from extension?)
      # TODO: options, syntax
      # TODO: SASS is a dependency, should we check if it's defined?
      # TODO: filter rule types here already?
      @tree = Sass::Engine.new(styles, :syntax => :sass).to_tree
    end

    # TODO: ensure that the first rule is of the correct type
    # TODO: deal with child, sibling and brother selectors
    # TODO: deal with new selector, starting with comma
    def parse(node = @tree.children.first, parent = nil)

      child_nodes = node.children.select {|c| c.is_a? Sass::Tree::RuleNode }
      selectors   = node.rule.first.split

      parent ||= Perseus::Selector.new(selectors.shift)
      @root  ||= parent

      # expand selectors from horizontal to vertical
      # '#foo .bar' => ['#foo, children: ['.bar, children: []]]
      selectors.each_with_index do |selector, index|
        parent.children << Perseus::Selector.new(selector)
        parent = parent.children.last if index == selectors.size - 1
      end

      parse(child_nodes.shift, parent) until child_nodes.empty?

      @root
    end

  end
end
