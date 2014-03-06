require 'spec_helper'

describe Perseus::Section do

  DEFAULTS = {
    :section      => '',
    :description  => '',
    :dependencies => [],
    :author       => '',
    :copyright    => '',
    :license      => '',
    :version      => ''
  }

  subject { Perseus::Section.new(:section => 'The section name') }

  describe '#blocks' do
    it 'exposes the blocks' do
      expect(subject).to respond_to(:blocks)
    end

    it 'returns an Array' do
      expect(subject.blocks).to be_an(Array)
    end
  end

  describe '#name' do
    it 'returns the section attribute' do
      expect(subject.name).to eq('The section name')
    end
  end

  describe '#dependencies', :focus => true do
    it 'returns an array if nothing specified' do
      expect(subject.dependencies).to be_an Array
    end

    it 'converts into an array if specified' do
      section = Perseus::Section.new(:section => 'The section name', :dependencies => 'foo, bar')
      expect(section.dependencies).to eq(['foo', 'bar'])
    end
  end

  describe 'defaults' do
    subject { Perseus::Section.new }

    DEFAULTS.each do |key, value|
      it "should have a default key ':#{key}' with value '#{value}'" do
        expect(subject).to respond_to(key)
        expect(subject.attributes).to have_key(key)
        expect(subject.send(key)).to eq(value)
      end
    end
  end


end
