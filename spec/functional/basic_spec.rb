require File.dirname(__FILE__) + '/../test_helper'

# TODO: use macro of sorts?
#
describe 'Basic conversion' do

  it 'should convert to correct html' do
    styles        = fixture :basic
    expected_html = fixture :basic, :html
    engine        = Perseus::Engine.new(styles)
    engine.render.must_equal expected_html
  end

end

describe 'Complex conversion' do

  it 'should convert to correct html' do
    styles        = fixture :complex
    expected_html = fixture :complex, :html
    engine        = Perseus::Engine.new(styles)
    engine.render.must_equal expected_html
  end

end
