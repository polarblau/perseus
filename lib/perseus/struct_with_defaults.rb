module Perseus
  module StructWithDefaults

    module ClassMethods
      def defaults(attributes = {})
        @attributes_with_defaults = attributes
      end

      def attributes_with_defaults
        @attributes_with_defaults
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end


    attr_reader :attributes

    def initialize(attributes = {})
      filtered_attributes = attributes.select {|key| members.include?(key) }
      @attributes         = defaults.merge(filtered_attributes)
    end

    def members
      defaults.keys
    end

    def defaults
       self.class.attributes_with_defaults
    end

    def method_missing(method, *arguments, &block)
      members.include?(method) ? @attributes[method] : super
    end

    def respond_to?(method, include_private = false)
      super || @attributes.has_key?(method)
    end

  end

end
