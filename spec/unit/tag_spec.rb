require File.dirname(__FILE__) + '/../test_helper'

describe Perseus::Tag do

  before :each do
    @selector = Perseus::Selector.new('#foo')
    @tag      = Perseus::Tag(@selector)
  end

  after :each do
    @selector =
    @tag      = nil
  end

  describe '#render' do

  end

end
