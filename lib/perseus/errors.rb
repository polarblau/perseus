module Perseus

  class ParserError < StandardError
    attr_reader :original

    def initialize(message, original = nil)
      message = message + "\n" + original.message if original
      super(message)
      @original = original
    end
  end

  class FileParserError < ParserError; end
  class ExampleParserError < ParserError; end

  class EngineError < StandardError; end

end
