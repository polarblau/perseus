module Perseus
  class Example

    MARKUP_TARGET_TYPE = :html
    MARKUP_TYPES = %i(html haml) # TODO: add slim

    STYLES_TARGET_TYPE = :css
    STYLES_TYPES = %i(css sass) # TODO: add scss

    attr_reader :attributes, :block

    def initialize(attributes, block)
      unless attributes.is_a? Hash
        raise ArgumentError.new(
          "The attributes argument must be a Hash, but #{attributes.class} was given."
        )
      end
      @attributes, @block = attributes, block
    end

    def markup
      @markup ||= generate_markup
    end

    def styles
      @styles ||= generate_styles
    end

  private

    def generate_markup
      type = (self.attributes.keys & MARKUP_TYPES).first
      return unless type

      do_compile = type != MARKUP_TARGET_TYPE
      generate_fragment(type, do_compile) if type
    end

    def generate_styles
      type = (self.attributes.keys & STYLES_TYPES).first
      return unless type

      do_compile = type != STYLES_TARGET_TYPE

      path = File.dirname(@block.file_path)
      # TODO: extract
      if block.dependencies.any?
        attributes[type] = block.dependencies.map {|dep|
          "@import '#{dep}'"
        }.join("\n") + "\n" + attributes[type]
      end
      fragment = generate_fragment(type, do_compile) if type
      fragment
    end

    def generate_fragment(type, do_compile)
      source, line, compiled = self.attributes[type], self.attributes[:line], nil
      compiled = compile(type, source, line) if do_compile

      ExampleFragment.new(type, source, compiled)
    end

    def compile(type, source, line)
      begin
        template = Tilt[type.to_s].new { source }
        output   = template.render
      rescue => e
        # FIXME: incorrect calculation, doesn't take example sections under
        # consideration
        relative_line = 0
        local_error   = e.backtrace.find { |m| m =~ /\(__TEMPLATE__\):/ }
        relative_line = local_error.split(':').last.to_i if local_error
        line          = block.line + @attributes[:line] + relative_line - 1

        raise ExampleParserError.new(
          "Parsing of #{type} example block failed in #{block.file_path}:#{line}.", e
        )
      end

      output
    end

  end

  ExampleFragment = Struct.new(:type, :source, :compiled)

end
