require 'spec_helper'
require 'tempfile'

describe Perseus::FileParser do
  describe '#parse' do

    context 'only section' do
      let(:section) { parse_styles("// @section: The section name") }
      
      it 'should return a section' do
        expect(section).to be_a(Perseus::Section)
      end
      
      it 'should identify the section name' do
        expect(section.name).to eq('The section name')
      end
      
      it 'shuold not find any blocks' do
        expect(section.blocks).to be_empty
      end
    end
    
    context 'section without name' do
      let(:section) { parse_styles("// @dependencies: bar, bat") }
      
      it 'should generate a section name from the file name' do
        expect(section.name).not_to be_empty
        expect(section.name).to match(/^Stylesheet/)
      end
    end
    
    context 'section with valid block' do
      let(:section) do
        parse_styles <<-EOS
// @section: The section name

// @name: The block name
EOS
      end
      
      it 'should contain one block' do
        expect(section.blocks).not_to be_empty
        expect(section.blocks.size).to be(1)
        expect(section.blocks.first.name).to eq('The block name')
      end 
      
    end
    
    context 'section with invalid block' do
      let(:section) do
        parse_styles <<-EOS
// @section: The section name

// @foo: bar
EOS
      end
      
      it 'should not contain any blocks' do
        expect(section.blocks).to be_empty
      end
    end
    
    context 'section with mutiple blocks' do
      let(:section) do
        parse_styles <<-EOS
// @section: The section name

// @name: First block name
.foo
  color: red

// @name: Second block name
.bar
  color: green
EOS
      end
      
      it 'should contain two blocks' do
        expect(section.blocks).not_to be_empty
        expect(section.blocks.size).to be(2)
        expect(section.blocks.first.name).to eq('First block name')
        expect(section.blocks.last.name).to eq('Second block name')
      end
    end
  end

  # USAGE:
  #
  #   styles = "// @section: The section name"
  #
  #   parse_styles styles do |path, section|
  #     expect(section).to be_a(Perseus::Section)
  #   end
  #
  #   or:
  #
  #   section = parse_styles(styles)
  def parse_styles(styles, &block)
    temp_file = Tempfile.new(['stylesheet', '.sass'])
    temp_file.write(styles)
    temp_file.rewind
    section = Perseus::FileParser.new(temp_file.path).parse
    yield(temp_file.path, section) if block_given?
    temp_file.close
    section
  end

end
