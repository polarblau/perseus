require File.dirname(__FILE__) + '/../test_helper'

describe Perseus::Parser do

  before do
    @basic_styles   = fixture(:basic)
    @complex_styles = fixture(:complex)
  end

  after do
    @parser = nil
  end

  describe '#parse' do
    describe 'basic styles' do

      before do
        @parser = Perseus::Parser.new(@basic_styles)
      end

      it 'parsing should be repeatable' do
        @parser.parse.wont_be_empty
        @parser.parse.wont_be_empty
      end

      it 'should return an Array' do
        @parser.parse.must_be_kind_of Array
      end

      it 'should return an Array of root nodes' do
        @parser.parse.first.must_be_kind_of Perseus::Selector
      end

      it 'the root selector should have only one child' do
        @parser.parse.size.must_equal 1
      end

    end

    describe 'complex styles' do

      before do
        @parser = Perseus::Parser.new(@complex_styles)
      end

      it 'the root selector should have two children' do
        @parser.parse.size.must_equal 2
      end

      it 'should return an Array' do
        @parser.parse.must_be_kind_of Array
      end

      it 'should return an Array of root nodes' do
        @parser.parse.first.must_be_kind_of Perseus::Selector
      end

      it 'the first root node must be have the text .bat' do
        @parser.parse.first.text.must_equal '.bat'
      end

    end

    describe '#parse_node' do

      before do
        @parser = Perseus::Parser.new('')
        # TODO: use mock? (messy in this case)
        @node   = Sass::Tree::RuleNode.new(['#foo'])
      end

      it 'must return a Perseus::Selector' do
        @parser.parse_node(@node).must_be_kind_of Perseus::Selector
      end

      # TODO: additional tests

    end

    describe '#extract_options_from_comment' do

      before do
        @parser = Perseus::Parser.new('')
      end

      # TODO: replace with higher level tests, instance_eval is iffy
      it 'should extract options add push them into the options buffer' do
        comment = MiniTest::Mock.new
        comment.expect :value, ['// @foo: bar']
        @parser.extract_options_from_comment(comment)
        @parser.instance_eval { @options_buffer }.must_include 'foo'
        @parser.instance_eval { @options_buffer['foo'] }.must_equal 'bar'
      end

    end

  end

end
