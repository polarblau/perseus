require File.dirname(__FILE__) + '/../../test_helper'

describe Hash do

  before do
    @hash = { :foo => 'bar' }
  end

  describe '#flush!' do

    it 'should empty the hash' do
      @hash.flush!
      @hash.must_be_empty
    end

     it 'should return the hash\'s content' do
      @hash.flush!.must_equal({ :foo => 'bar' })
    end

  end

end
