require 'perseus/parser'
require 'perseus/selector'
require 'perseus/tag'
require 'perseus/compiler'

module Perseus
  class Engine

    # TODO: caching --> only parse and compile if files have changed
    # TODO: accept file for styles (detect syntax from extension?)
    def initialize(styles)
      parser    = Perseus::Parser.new(styles)
      @compiler = Perseus::Compiler.new(parser.parse)
    end

    def render
      @compiler.compile
    end

  end
end
