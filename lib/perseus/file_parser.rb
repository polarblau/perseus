module Perseus

  class FileParser

    def initialize(file_path)
      @file_path = file_path
    end

    def parse
      begin
        sass_engine = Sass::Engine.for_file(@file_path, {})
        tree        = sass_engine.to_tree
      rescue Sass::SyntaxError => e
        raise FileParserError.new("Parsing of stylesheet (#{@file_path}) failed.", e)
      end

      section = traverse_tree(tree)
    end

  private

    def traverse_tree(tree)
      nodes           = tree.children.dup
      current_section = nil
      current_block   = nil

      until nodes.empty?
        node = nodes.shift

        if node.is_a? Sass::Tree::CommentNode
          attributes = parse_comment_block(node.value)
          next if attributes.empty?

          # mix the current file path and block line into the attributes
          attributes[:file_path] = @file_path
          attributes[:line]      = node.line

          # the first comment block must define the section
          if current_section.nil?
            file_name = File.basename(@file_path, ".*")
            attributes[:section] = humanize(file_name) unless attributes[:section]
            current_section = Section.new(attributes)

          else
            # commit the previous current block as we're parsing the next
            current_section.blocks << current_block if current_block && current_block.valid?
            current_block = Block.new(current_section, attributes)
          end

        else
          # enrich current_block with some additional information here,
          # e.g. name of mixin or placeholder, code contained in next node,
          # linenumber of next node, …
        end
      end

      if current_section
        # TODO: DRY?
        current_section.blocks << current_block if current_block && current_block.valid?

        unless current_section.name
          file_name = File.basename(@file_path, File.extname(@file_path))
          current_section.add_attribute :section, humanize(file_name)
        end
      end

      current_section
    end

    def parse_comment_block(lines)
      lines = clean_lines(lines)
      extract_attributes_from_lines(lines)
    end

    # TODO: simplify
    def extract_attributes_from_lines(lines, &block)
      attributes    = {}
      current_scope = nil
      current_flag  = nil

      lines.each_with_index do |line, index|
        line.rstrip!

        # looks like a regular attribute
        if line =~ /^@/
          key, value = line.scan(/@([\w_]*):(.*)/).flatten.map(&:strip).reject(&:empty?)
          key        = key.to_sym

          # yup, it's a regular attribute, save and reset flags
          if value
            # TODO: DRY!
            attributes[current_scope] = normalize_scoped_lines(attributes[current_scope]) if current_scope

            current_scope   = nil
            current_flag    = nil

            attributes[key] = value

          # no value -- looks like a scope: open scope and record line number
          else
            current_scope   = key
            attributes[key] = { :line => index + 1 }
          end

        # looks like a flag: create container for it if we have an open scope
        elsif line =~ /^\[(.*)\]$/ && current_scope
          current_flag = line.scan(/^\[(.*)\]$/).flatten.first.to_sym
          attributes[current_scope][current_flag] = []

        # something else, but we have an open scope and flag so let's record the line there
        elsif current_scope && current_flag
          attributes[current_scope][current_flag] << line

        # simple string outside scope or flag -- do nothing?
        else
          # Meeh, wat?
        end
      end

      # TODO: DRY! (see above)
      attributes[current_scope] = normalize_scoped_lines(attributes[current_scope]) if current_scope

      attributes
    end

    def clean_lines(lines)
      lines = compact_lines(lines)
      lines = normalize_lines(lines)
    end

    # remove indicators and other junk
    def compact_lines(lines)
      lines.map!(&:to_s)
      # remove line breaks "\n" and separators "// ---"
      lines.reject! {|line| line =~ /^(\/\/\s-{3,}|\n)/ }
      # remove leading comment indicators "//", "/*", " *"
      lines.map! {|line| line.sub(/^(\/\/|\/\*|\s\*)/, '') }
      # remove trailing comment indicators "*/"
      lines.map! {|line| line.sub(/\*\/$/, '') }.map(&:rstrip)
      # remove after all empty lines
      lines.reject(&:empty?)
    end

    # remove consistently preceding whitespace
    def normalize_lines(lines)
      whitespace = lines.map {|line| line.scan(/^\s*/).first.to_s.size }
      common_indentation = whitespace.min
      lines.map {|line| line.slice(common_indentation..-1) }
    end

    # normalize lines within scope and join them
    def normalize_scoped_lines(attributes)
      attributes.inject({}) do |memo, (flag, lines)|
        memo[flag] = if lines.is_a? Array
          normalize_lines(lines).join("\n")
        else
          lines
        end

        memo
      end
    end

    # TODO: move into Utils
    def humanize(string)
      result = string.tr('_', ' ').tr('-', ' ')
      result.gsub(/([a-z\d]*)/) { |match| match.downcase }.gsub(/^\w/) { $&.upcase }
    end

  end

end
