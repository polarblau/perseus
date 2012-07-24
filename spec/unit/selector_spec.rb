require File.dirname(__FILE__) + '/../test_helper'

describe Perseus::Selector do

  before :each do
    @selector = Perseus::Selector.new('#foo')
  end

  after :each do
    @selector = nil
  end

  it 'has no children by default' do
    @selector.children.must_be_empty
  end

  describe '#to_html' do

    it 'returns a div tag by default' do
      @selector.to_html.must_match /^<div/
    end

  end

  describe '#id' do
    it 'should return the id if available' do
      @selector.id.must_equal 'foo'
    end

    it 'should return nil if no id defined' do
      @selector = Perseus::Selector.new('.foo')
      @selector.id.must_be_nil
    end
  end

  describe '#has_id' do
    it 'should return true if an id is available' do
      @selector.has_id?.must_equal true
    end

    it 'should return false if no id defined' do
      @selector = Perseus::Selector.new('.foo')
      @selector.has_id?.must_equal false
    end
  end

  describe '#classes' do
    it 'should return an Array' do
      @selector.classes.must_be_kind_of Array
    end

    it 'should return a class if available' do
      @selector = Perseus::Selector.new('.bar')
      @selector.classes.must_equal ['bar']
    end

    it 'should return multiple classes' do
      @selector = Perseus::Selector.new('.foo.bar')
      @selector.classes.must_equal ['foo', 'bar']
    end

    it 'should return multiple classes if defined within text' do
      @selector = Perseus::Selector.new('img.foo.bar')
      @selector.classes.must_equal ['foo', 'bar']
    end

    it 'should return an empty array if no classes are available' do
      @selector.classes.must_be_empty
    end
  end

  describe '#has_classes' do
    it 'should return true if a class is available' do
      @selector = Perseus::Selector.new('.foo')
      @selector.has_classes?.must_equal true
    end

    it 'should return true if multiple classes are available' do
      @selector = Perseus::Selector.new('.foo.bar')
      @selector.has_classes?.must_equal true
    end

    it 'should return true if a class is defined within the text' do
      @selector = Perseus::Selector.new('img.foo')
      @selector.has_classes?.must_equal true
    end

    it 'should return true if multiple classes are defined within the text' do
      @selector = Perseus::Selector.new('img.foo.bar')
      @selector.has_classes?.must_equal true
    end

    it 'should return false if no class is defined' do
      @selector.has_classes?.must_equal false
    end
  end

  describe '#attributes' do

    it 'should should include the id' do
       @selector.to_html.must_match /^<div id="foo">/
    end

  end

end
