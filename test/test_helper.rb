require 'bundler/setup'
require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'sass'

def fixture(file, type = :sass)
  File.read fixture_path(file, type)
end

def fixture_path(file, type = :sass)
  "#{File.dirname(__FILE__)}/fixtures/#{file}.#{type}"
end
