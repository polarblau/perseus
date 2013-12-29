module Perseus

  def self.defaults
    {
      # TODO: document here?
      :block_defaults   => {
        :name         => '',
        :description  => '',
        :selector     => '',
        :mixin        => '',
        :placeholder  => '',
        :states       => [],
        :extends      => [],
        :includes     => [],
        :arguments    => {},
        :example      => nil
      },
      :section_defaults => {
        :section      => '',
        :description  => '',
        :dependencies => [],
        :author       => '',
        :copyright    => '',
        :license      => '',
        :version      => '',
        :file_path    => ''
      },
      :example_resolver => nil
    }
  end

  def self.configuration
    @configuration ||= OpenStruct.new(self.defaults)
  end

  def self.configure(&block)
    yield(configuration) if block_given?
  end
end