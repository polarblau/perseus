require 'spec_helper'

describe 'Simple parser case' do

  let(:engine) { Perseus::Engine.new(fixtures_path('stylesheets/simple')) }

  it 'should return a single section' do
    expect(engine.sections.size).to eq(1)
  end

  describe 'section' do
    subject(:section) { engine.sections.first }

    it 'should have the correct name' do
      expect(section.name).to eq('Name for a simple section')
    end
  end

end
