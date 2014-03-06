require 'spec_helper'

describe Perseus::Example do

  # TODO: remove duplication

  let(:block) { double('Perseus::Block', :file_path => 'specs/fixtures/stylesheets/simple.sass') }
  let(:block_with_deps) { double('Perseus::Block', :file_path    => 'spec/fixtures/stylesheets/simple.sass',
                                                   :dependencies => ['dependencies/a']) }
  let(:simple_attributes) { { :line => 1                                     } }
  let(:haml_attributes)   { { :line => 1, :haml => '#foo bar'                } }
  let(:html_attributes)   { { :line => 1, :html => '<div id="foo">bar</div>' } }
  let(:sass_attributes)   { { :line => 1, :sass => "#foo\n  color: red"      } }
  let(:deps_attributes)   { { :line => 1, :sass => "#foo\n  @extend %foo"    } }
  let(:css_attributes)    { { :line => 1, :css => "#foo {\n  color: red;\n}" } }

  let(:simple_example)    { Perseus::Example.new(simple_attributes, block)   }
  let(:haml_example)      { Perseus::Example.new(haml_attributes, block)     }
  let(:html_example)      { Perseus::Example.new(html_attributes, block)     }
  let(:sass_example)      { Perseus::Example.new(sass_attributes, block)     }
  let(:css_example)       { Perseus::Example.new(css_attributes, block)      }
  let(:sass_example)      { Perseus::Example.new(sass_attributes, block)     }
  let(:deps_example)      { Perseus::Example.new(deps_attributes, block_with_deps) }

  describe 'constructor' do
    it 'should throw an error if faulty attributes are supplied' do
      expect { Perseus::Example.new('Some string', block) }.to(raise_error(
        ArgumentError, "The attributes argument must be a Hash, but String was given."
      ))
    end

    it 'should expose the attributes' do
      expect(simple_example.attributes).to be(simple_attributes)
    end
  end

  describe '#markup' do
    it 'should return nil if the attributes do not contain markup' do
      expect(simple_example.markup).to be_nil
    end

    it 'should return a fragment' do
      expect(html_example.markup).to be_a(Perseus::ExampleFragment)
    end

    it 'should memoize the result' do
      markup = html_example.markup
      expect(html_example.markup).to be(markup)
    end

    it 'should raise an error with proper line number if faulty source is provided' do
      bad_source = "%h1 bar\n#foo baz\n  bat"
      example = Perseus::Example.new({ :line => 123, :haml => bad_source }, block)

      expect { example.markup }.to raise_error(Perseus::ExampleParserError)
      begin
        example.markup
      rescue => error
      ensure
        expect(error.message).to eq("Parsing of haml example block failed in /foo/bar.sass:126.")
      end
    end

    # Perseus::ExampleFragment is just an inline struct so we'll test it here:

    it 'should define #source always' do
      expect(html_example.markup.source).not_to be_nil
      expect(html_example.markup.source).to eq('<div id="foo">bar</div>')
      expect(haml_example.markup.source).not_to be_nil
      expect(haml_example.markup.source).to eq('#foo bar')
    end

    it 'should define #type' do
      expect(haml_example.markup.type).to be(:haml)
      expect(html_example.markup.type).to be(:html)
    end

    it 'should define #compiled' do
      expect(haml_example.markup.compiled).not_to be_nil
    end

    it 'should not define #compiled if compilation is not required' do
      expect(html_example.markup.compiled).to be_nil
    end

    it 'should compile haml markup' do
      expect(haml_example.markup.compiled).to eq("<div id='foo'>bar</div>\n")
    end
  end

  describe '#styles' do
    it 'should return nil if the attributes do not contain styles' do
      expect(simple_example.styles).to be_nil
    end

    it 'should return a fragment' do
      expect(css_example.styles).to be_a(Perseus::ExampleFragment)
    end

    it 'should memoize the result' do
      styles = html_example.styles
      expect(css_example.markup).to be(styles)
    end

    it 'should raise an error with proper line number if faulty source is provided' do
      bad_source = ".foo\n  color:\n  background: red"
      example = Perseus::Example.new({ :line => 123, :sass => bad_source }, block)

      expect { example.styles }.to raise_error(Perseus::ExampleParserError)
      begin
        example.styles
      rescue => error
      ensure
        expect(error.message).to eq("Parsing of sass example block failed in /foo/bar.sass:125.")
      end
    end

    # Perseus::ExampleFragment is just an inline struct so we'll test it here:

    it 'should define #source always' do
      expect(css_example.styles.source).not_to be_nil
      expect(css_example.styles.source).to eq("#foo {\n  color: red;\n}")
      expect(sass_example.styles.source).not_to be_nil
      expect(sass_example.styles.source).to eq("#foo\n  color: red")
    end

    it 'should define #type' do
      expect(sass_example.styles.type).to be(:sass)
      expect(css_example.styles.type).to be(:css)
    end

    it 'should define #compiled if compilation is required' do
      expect(sass_example.styles.compiled).not_to be_nil
    end

    it 'should not define #compiled if compilation is not required' do
      expect(css_example.styles.compiled).to be_nil
    end

    it 'should compile sass styles' do
      expect(sass_example.styles.compiled).to eq("#foo {\n  color: red; }\n")
    end

    context 'style dependencies' do
      it 'should import dependencies', :focus => true do
        expect(deps_example.styles.compiled).to eq("#foo {\n  color: green; }\n")
      end
    end
  end
end
