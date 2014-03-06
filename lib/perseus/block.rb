module Perseus
  class Block
    include StructWithDefaults
    extend Forwardable

    def_delegators :@section, :dependencies, :file_path

    attr_reader :section

    defaults Perseus.configuration.block_defaults

    def initialize(section, attributes = {})
      @section = section
      super(attributes)
    end

    def valid?
      # TODO: simplify
      @attributes.has_key?(:name) && !@attributes[:name].empty?
    end

    def example
      @example ||= generate_example
    end

  private

    def generate_example
      if (example = @attributes[:example])
        # TODO: use define Perseus::Example as default and simplify?
        example_klass = Perseus.configuration.example_resolver || Example
        example_klass.send(:new, example, self)
      end
    end

  end

end
