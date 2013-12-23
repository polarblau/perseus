module Perseus

  class Section
    include StructWithDefaults

    defaults :section      => '',
             :description  => '',
             :dependencies => [],
             :author       => '',
             :copyright    => '',
             :license      => '',
             :version      => ''

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
