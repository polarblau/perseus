module Perseus

  class Section
    include StructWithDefaults

    defaults Perseus.configuration.section_defaults

    attr_accessor :blocks

    def initialize(attributes = {})
      super
      @blocks = []
    end

    def name
      @attributes[:section]
    end

    def dependencies
      if @attributes[:dependencies].respond_to? :split
        @attributes[:dependencies].split(',').map(&:strip)
      else
        super
      end
    end

  end

end
