lib_dir = File.dirname(__FILE__) + '/../lib'

require 'bundler/setup'
require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'sass'

$:.unshift lib_dir unless $:.include?(lib_dir)

require 'perseus'
require 'perseus/parser'
require 'perseus/compiler'
require 'perseus/selector'

def fixture(file, type = :sass)
  File.read fixture_path(file, type)
end

def fixture_path(file, type = :sass)
  "#{File.dirname(__FILE__)}/fixtures/#{file}.#{type}"
end
