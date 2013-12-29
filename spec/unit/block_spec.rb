require 'spec_helper'
require 'pry'

describe Perseus::Block do

  let(:section)   { double('Perseus::Section', :file_path    => 'foo/bar.sass',
                                               :dependencies => [])             }
  subject(:block) { Perseus::Block.new(section, :name => 'The block name')      }

  DEFAULTS = {
    :name        => '',
    :description => '',
    :selector    => '',
    :mixin       => '',
    :placeholder => '',
    :states      => [],
    :extends     => [],
    :includes    => [],
    :arguments   => {},
    :example     => nil
  }

  describe '#valid?' do
    it 'returns true if a "name" attribute has been defined' do
      expect(block.valid?).to be(true)
    end

    it 'returns true if a "name" attribute has not been defined' do
      block = Perseus::Block.new(section)
      expect(block.valid?).to be(false)
    end
  end

  describe '#file_path' do
    it 'shold delegate #file_path to section' do
      block.file_path
      expect(section).to have_received(:file_path)
    end
  end

  describe '#dependencies' do
    it 'shold delegate #dependencies to section' do
      block.dependencies
      expect(section).to have_received(:dependencies)
    end
  end

  describe '#example' do

    let(:example)   { { :line => 123, :haml => '%h1 foo' }             }
    subject(:block) { Perseus::Block.new(section, :example => example) }

    it 'creates a new instance of Example' do
      expect(Perseus::Example).to receive(:new).with(example, block)
      block.example
    end
    
    it 'should set #example to an instance of the built-in Example class' do
      expect(block.example).to be_a(Perseus::Example)
    end

    it 'returns nil if no example has been specified' do
      block = Perseus::Block.new(section)
      expect(block.example).to be_nil
    end

    it 'returns an example if the attributes define one' do
      block = Perseus::Block.new(section, :example => { :line => 123, :haml => '%h1 foo' })
      expect(block.example).to_not be_nil
      # sanity check, may be moved to functional tests
      expect(block.example.styles).to be_nil
      expect(block.example.markup).to_not be_nil
    end

    describe 'custom example resolver' do
      class CustomExample < Perseus::Example; end
      
      before do
        Perseus.configure do |config|
          config.example_resolver = CustomExample
        end
      end

      it 'should use a custom resolver if defined' do
        expect(CustomExample).to receive(:new).with(example, block)
        block.example
      end
      
      it 'should set #example' do
        expect(block.example).to be_a(CustomExample)
      end
    end
  end

  describe 'defaults' do
    subject(:block) { Perseus::Block.new(section) }

    DEFAULTS.each do |key, value|
      it "should have a default key ':#{key}' with value '#{value}'" do
        expect(block).to respond_to(key)
        expect(block.attributes).to have_key(key)
        expect(block.send(key)).to eq(value)
      end
    end
  end

end
