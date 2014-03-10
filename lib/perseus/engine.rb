module Perseus

  class Engine

    attr_accessor :sections
    attr_accessor :pool

    def initialize(path)
      @sections = []

      if Dir.exists?(path)
        # TODO: better way?
        Sass.load_paths << path
        Sass.load_paths.uniq!

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

# require 'pstore'
#
# store = PStore.new('perseus.pstore')
#
# def write_cache(sections)
#   store.transaction do
#     store[:sections] = Marshal.dump(sections)
#   end
# end
#
# def read_cache
#   store.transaction do
#     Marshal.load(store[:sections])
#   end
# end
