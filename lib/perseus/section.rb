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

  end

end
