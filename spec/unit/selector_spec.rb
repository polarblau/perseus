require File.dirname(__FILE__) + '/../test_helper'

describe Perseus::Selector do

  before do
    @selector = Perseus::Selector.new('#foo')
  end

  # basics
  it '#to_s returns the full selector text' do
    @selector.to_s.must_equal '#foo'
  end

  it 'has no children by default' do
    @selector.children.must_be_empty
  end

end
