require 'spec_helper'

describe Perseus::Block do
  
  subject { Perseus::Block.new(:name => 'The block name') }
  
  DEFAULTS = {
    :name        => '',
    :description => '',
    :selector    => '',
    :mixin       => '',
    :placeholder => '',
    :states      => [],
    :group       => '',
    :category    => '',
    :extends     => [],
    :includes    => [],
    :arguments   => {},
    :markup      => nil,
    :styles      => nil
  }
  
  describe '#valid?' do 
    it 'returns true if a "name" attribute has been defined' do
      expect(subject.valid?).to be(true)
    end
    
    it 'returns true if a "name" attribute has not been defined' do
      block = Perseus::Block.new 
      expect(block.valid?).to be(false)
    end
  end
  
  
  describe 'defaults' do
    subject { Perseus::Block.new }
        
    DEFAULTS.each do |key, value|
      it "should have a default key ':#{key}' with value '#{value}'" do
        expect(subject).to respond_to(key)
        expect(subject.attributes).to have_key(key)
        expect(subject.send(key)).to eq(value)
      end
    end
  end

end