require File.dirname(__FILE__) + '/../test_helper'

describe Perseus::Compiler do

  before do
    @root     = MiniTest::Mock.new
    @compiler = Perseus::Compiler.new(@root)
  end

  it 'should call #to_html on the root selector' do
    @root.expect :to_html, ''
    @compiler.compile
    @root.verify
  end

end
