require 'spec_helper'

describe HamlCoffeeAssets do
  describe '.config' do
    it 'returns the configuration object' do
      expect(HamlCoffeeAssets.config).to be_an_instance_of ::HamlCoffeeAssets::Configuration
    end
  end

  describe '.helpers' do
    it "returns the global context from asset pipeline" do
      expect(HamlCoffeeAssets::GlobalContext).to receive(:to_s).and_return("foo")
      helpers = HamlCoffeeAssets.helpers
      expect(helpers).to match(/foo/)
    end

    context 'with compilation enabled' do
      it 'returns the helpers as JavaScript' do
        helpers = HamlCoffeeAssets.helpers
        expect(helpers).to match(/HAML.escape/)
        expect(helpers).to match(/HAML.cleanValue/)
        expect(helpers).to match(/HAML.extend/)
        expect(helpers).to match(/HAML.globals/)
        expect(helpers).to match(/HAML.context/)
        expect(helpers).to match(/HAML.preserve/)
        expect(helpers).to match(/HAML.findAndPreserve/)
        expect(helpers).to match(/HAML.surround/)
        expect(helpers).to match(/HAML.succeed/)
        expect(helpers).to match(/HAML.precede/)
        expect(helpers).to match(/HAML.reference/)
      end
    end

    context 'with compilation disabled' do
      it 'returns the helpers as CoffeeScript' do
        helpers = HamlCoffeeAssets.helpers(false)
        expect(helpers).to match(/@escape/)
        expect(helpers).to match(/@cleanValue/)
        expect(helpers).to match(/@extend/)
        expect(helpers).to match(/@globals/)
        expect(helpers).to match(/@context/)
        expect(helpers).to match(/@preserve/)
        expect(helpers).to match(/@findAndPreserve/)
        expect(helpers).to match(/@surround/)
        expect(helpers).to match(/@succeed/)
        expect(helpers).to match(/@precede/)
        expect(helpers).to match(/@reference/)
      end
    end
  end
end
