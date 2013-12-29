module Perseus

  class Engine

    attr_accessor :sections
    attr_accessor :pool

    def initialize(path)
      @sections = []

      if Dir.exists?(path)
        # TODO: parse dirs recursively and store structured
        @pool = Dir["#{path}/**/*.{css,sass,scss}"].each do |file_path|
          parser = FileParser.new(file_path)
          @sections << parser.parse
        end

        @sections.compact!
      else
        raise EngineError.new("Invalid path ('#{path}') supplied.")
      end
    end

  end

end
