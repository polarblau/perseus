require File.dirname(__FILE__) + '/../test_helper'

describe Perseus::Tag do

  before :each do
    @selector = MiniTest::Mock.new
    @tag      = Perseus::Tag.new(@selector)
  end

  # TODO: this clearly sucks and should be fixed:
  # TODO: at least check that #tag and #children should be called Nx
  def selector_expectations(expectations = {})
    3.times {
      @selector.expect :tag,           expectations[:tag]        || 'div'
    }
    2.times {
      @selector.expect :children,      expectations[:children]   || []
    }
    @selector.expect   :attributes,    expectations[:attributes] || {}
  end

  after :each do
    @selector = nil
    @tag      = nil
  end

  describe '#render' do

    it 'should render a div tag' do
      selector_expectations
      @tag.render.must_match /<div>.*<\/div>\n/
    end

    it 'should render a div tag with attributes' do
      selector_expectations :attributes => { 'class' => 'foo' }
      @tag.render.must_match /<div class=\"foo\">.*<\/div>\n/
    end

    it 'should render a div tag with child element' do
      # TODO: mock child_div?
      child_div = Perseus::Selector.new('div')
      selector_expectations :children =>  [child_div]
      @tag.render.must_match /<div>\n  <div>.*<\/div>\n<\/div>\n/
    end

  end

  describe '#name' do

    it 'should return the tag name' do
      @selector.expect :tag, 'img'
      @tag.name.must_equal 'img'
    end

  end

  describe '#self_closing?' do

    it 'should return true for img, br or hr tags' do
      %w(img br hr).each do |tag|
        @selector.expect :tag, tag
        @tag.self_closing?.must_equal true
      end
    end

    it 'should return false for regular tags' do
      @selector.expect :tag, 'div'
      @tag.self_closing?.must_equal false
    end

  end


  describe '#attributes' do

    it 'returns an empty string if no attributes are defined' do
      @selector.expect :attributes, {}
      @tag.attributes.must_be_empty
    end

    it 'returns a formatted string for a key:value pair' do
      @selector.expect :attributes, { 'foo' => 'bar' }
      @tag.attributes.must_equal ' foo="bar"'
    end

    it 'returns a string, starting with whitespace' do
      @selector.expect :attributes, { 'foo' => 'bar' }
      @tag.attributes[0,1].must_equal ' '
    end

  end

  describe '#content' do

    it 'should retun the content if defined as option' do
      @tag = Perseus::Tag.new(@selector, {'content' => 'Foobar'})
      @tag.content.must_equal 'Foobar'
    end

  end

end
