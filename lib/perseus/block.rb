module Perseus

  class Block
    include StructWithDefaults
    
    defaults :name        => '',
             :description => '',
             :selector    => '',
             :mixin       => '',
             :placeholder => '',
             :states      => [],
             :group       => '',
             :category    => '',
             :extends     => [],
             :includes    => [],
             :arguments   => {},
             :markup      => nil,
             :styles      => nil

    MARKUP_TYPES = %i(html haml slim)
    STYLES_TYPES = %i(css sass scss)

    def valid?
      @attributes.has_key?(:name) and not @attributes[:name].empty?
    end

    # TODO: test that always returns a meaningful data object
    def markup
      type, value = markup_source
      return if type.nil?

      source, line = value[:source], value[:line]
      
      @markup ||= OpenStruct.new(
        :type     => type,
        :line     => line,
        :source   => source,
        :compiled => compile(type, source, line)
      )
    end

    # TODO: test that always returns a meaningful data object
    def styles
      type, value = styles_source
      return if type.nil?

      source, line = value[:source], value[:line]
      source_with_dependencies = import_styles_dependencies(source, type)

      Sass.load_paths << File.dirname(@attributes[:path])
      @styles ||= OpenStruct.new(
        :type     => type,
        :line     => line,
        :source   => source,
        # TODO: ensure that this we're only returning what makes sense here!
        :compiled => compile(type, source_with_dependencies, line)
      )

      # TODO: NOT THREAD SAFE!
      Sass.load_paths.pop

      @styles
    end

  private

    def markup_source
      @attributes.find {|key, attrs| MARKUP_TYPES.include?(key) }
    end

    def styles_source
      @attributes.find {|key, attrs| STYLES_TYPES.include?(key) }
    end

    def import_styles_dependencies(source, type)
      dependencies = @attributes[:dependencies].map { |dependency|
        # TODO: de–couple from type
        "@import #{dependency}#{ ';' unless type == :sass }\n"
      }.join('')
      source.to_s.dup.prepend(dependencies)
    end

    def compile(type, source, line)
      return if type.nil? or source.nil?

      begin
        template = Tilt[type.to_s].new { source }
        output   = template.render
      rescue => e
        line_within_block = e.backtrace.first.split(':').last.to_i
        line = line + self.line + line_within_block
        raise BlockParserError.new(
          "Parsing of #{type} example block failed in #{path}:#{line}.", e
        )
      end

      output
    end

  end

end
