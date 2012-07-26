require File.dirname(__FILE__) + '/../test_helper'

describe Perseus::Compiler do

  before do
    @selector = MiniTest::Mock.new
    @compiler = Perseus::Compiler.new([@selector])
  end

  it 'should call #to_html on the root selector' do
    @selector.expect :to_html, ''
    @compiler.compile
    @selector.verify
  end

end
