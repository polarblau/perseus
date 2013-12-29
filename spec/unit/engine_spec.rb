require 'spec_helper'

describe Perseus::Engine do
  
  let(:engine) { Perseus::Engine.new(fixtures_path('stylesheets')) }
  
  it 'should return an array of sections' do
    expect(engine.sections).to be_an Array
    expect(engine.sections.map(&:class).uniq).to eq([Perseus::Section])
  end
  
  it 'should throw an EngineError if an invalid path is supplied' do
    expect { Perseus::Engine.new('does/not/exist') }.to(raise_error(
      Perseus::EngineError, "Invalid path ('does/not/exist') supplied."
    ))
  end
  
end