require 'spec_helper'

class Dummy
  include Perseus::StructWithDefaults
  defaults :foo => 'original foo', :bar => 'original bar'
end

describe Perseus::StructWithDefaults do

  subject(:instance) { nstance = Dummy.new(:foo => 'new foo') }

  describe '#initialize' do
    it 'should set the attributes' do
      expect(instance.attributes).to include(:foo)
      expect(instance.attributes[:foo]).to eq('new foo')
    end

    it 'should not set extra attributes' do
      instance = Dummy.new(:other => 'something')
      expect(instance.attributes).not_to include(:other)
    end
  end

  describe '#members' do
    it 'returns the keys for all available attributes' do
      expect(instance.members).to eq([:foo, :bar])
    end
  end
  
  describe '#defaults' do
    it 'returns a hash with the default attributes and their values' do
      expect(instance.defaults).to eq({ :foo => 'original foo', :bar => 'original bar' })
    end
  end

  describe 'attribute access through dynamic methods' do
    it 'should define a method for an attribute' do
      expect(instance).to respond_to(:foo)
    end

    it 'should not define a method for defaults' do
      expect(instance).to respond_to(:bar)
    end

    it 'should return the value for an attribute' do
      expect(instance.foo).to eq(instance.attributes[:foo])
      expect(instance.foo).to eq('new foo')
    end

    it 'should raise a NoMethodError if an attribute has not been defined' do
      expect { instance.other }.to raise_error(NoMethodError)
    end
  end
end
