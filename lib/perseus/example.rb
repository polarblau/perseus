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
      generate_fragment(type, do_compile) if type
    end

    def generate_fragment(type, do_compile)
      source, line, compiled = self.attributes[type], self.attributes[:line], nil
      compiled = compile(type, source, line) if do_compile

      ExampleFragment.new(type, source, compiled)
    end

    def compile(type, source, line)
      begin
        template      = Tilt[type.to_s].new { source }
        output        = template.render
      rescue => e
        relative_line = e.backtrace.first.split(':').last.to_i
        line          = line + relative_line

        raise ExampleParserError.new(
          "Parsing of #{type} example block failed in #{block.file_path}:#{line}.", e
        )
      end

      output
    end

  end

  ExampleFragment = Struct.new(:type, :source, :compiled)

end
