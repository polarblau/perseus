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

    it 'returns a String' do
      @selector.to_html.must_be_kind_of String
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

  describe '#pseudo' do

    it 'returns the pseudo selector if defined' do
      @selector = Perseus::Selector.new('li:first-child')
      @selector.pseudo.must_equal 'first-child'
    end

    it 'returns nil if no pseudo selector is defined' do
      @selector.pseudo.must_be_nil
    end

  end

  describe '#inline_attributes' do

    it 'should return a hash' do
      @selector.inline_attributes.must_be_kind_of Hash
    end

    it 'should return a key:value dictionary of the attribute' do
      @selector = Perseus::Selector.new('img[alt=foo]')
      @selector.inline_attributes.must_equal({'alt' => 'foo'})
    end
  end

  describe '#attributes' do

    it 'should should include the id' do
      @selector.attributes.must_include 'id'
    end

    it 'should should return the correct value for id' do
      @selector.attributes['id'].must_equal 'foo'
    end

    it 'should should not include a class' do
      @selector.attributes.wont_include 'class'
    end

    it 'should should include a class if defined' do
      @selector = Perseus::Selector.new('.bar')
      @selector.attributes.must_include 'class'
      @selector.attributes['class'].must_equal 'bar'
    end

    it 'should should include a class as String' do
      @selector = Perseus::Selector.new('.bar')
      @selector.attributes['class'].must_be_kind_of String
    end

    it 'should should include multiple classes' do
      @selector = Perseus::Selector.new('.bar.bat')
      @selector.attributes.must_include 'class'
    end

    it 'should should include multiple classes joined by whitespace' do
      @selector = Perseus::Selector.new('.bar.bat')
      @selector.attributes['class'].must_equal 'bar bat'
    end

    it 'should include inline attributes' do
      @selector = Perseus::Selector.new('img[alt=foo]')
      @selector.attributes.must_include 'alt'
      @selector.attributes['alt'].must_equal 'foo'
    end

    it 'should include inline- as well as regular attributes' do
      @selector = Perseus::Selector.new('img.bar[alt=foo]')
      @selector.attributes.must_include 'alt'
      @selector.attributes.must_include 'class'
      @selector.attributes.must_equal({ 'class' => 'bar', 'alt' => 'foo' })
    end

  end

  describe '#tag' do

    it 'returns a String' do
      @selector.tag.must_be_kind_of String
    end

    it 'returns a div if no other tag can be found' do
      @selector.tag.must_equal 'div'
    end

    it 'returns the tag if it can be found' do
      @selector = Perseus::Selector.new('img')
      @selector.tag.must_equal 'img'
    end

    it 'returns the tag if a class is present' do
      @selector = Perseus::Selector.new('img.foo')
      @selector.tag.must_equal 'img'
    end

    it 'returns the tag if multiple classes are present' do
      @selector = Perseus::Selector.new('img.foo.bar')
      @selector.tag.must_equal 'img'
    end

    it 'returns the tag if multiple classes and an id are present' do
      @selector = Perseus::Selector.new('img#bat.foo.bar')
      @selector.tag.must_equal 'img'
    end

    it 'returns the tag if an id is present' do
      @selector = Perseus::Selector.new('img#foo')
      @selector.tag.must_equal 'img'
    end

    it 'returns the tag if an attribute is present' do
      @selector = Perseus::Selector.new('img[alt=foo]')
      @selector.tag.must_equal 'img'
    end

    it 'returns the tag if an attribute, classes and an id are present' do
      @selector = Perseus::Selector.new('img#bar.foo.bar[alt=foo]')
      @selector.tag.must_equal 'img'
    end

    it 'returns the tag if a pseudo selector is present' do
      @selector = Perseus::Selector.new('a:hover')
      @selector.tag.must_equal 'a'
    end

  end

end
