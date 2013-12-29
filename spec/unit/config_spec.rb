require 'ostruct'
require 'perseus/config'

describe Perseus do

  describe '#defaults' do
  end

  describe '#configuration' do
  end

  describe '#configure' do
    subject(:configuration) { Perseus.configuration }

    it 'should set configuration values in a block' do
      expect(configuration).not_to respond_to(:foobar)

      Perseus.configure do |config|
        config.foobar = 'barfoo'
      end

      expect(configuration).to respond_to(:foobar)
      expect(configuration.foobar).to eq('barfoo')
    end
  end

end
