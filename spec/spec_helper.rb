require 'perseus'
require 'pry'

def fixture(file)
  File.read fixtures_path(file)
end

def fixtures_path(path)
  File.join(File.dirname(__FILE__), 'fixtures', path)
end
