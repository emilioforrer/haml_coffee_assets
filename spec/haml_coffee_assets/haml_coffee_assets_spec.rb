require 'spec_helper'

describe HamlCoffeeAssets do
  describe '.config' do
    it 'returns the configuration object' do
      HamlCoffeeAssets.config.should be_an_instance_of ::HamlCoffeeAssets::Configuration
    end
  end

  describe '.helpers' do
    it "returns the global context from asset pipeline" do
      HamlCoffeeAssets::GlobalContext.stub(:to_s) { "foo" }
      helpers = HamlCoffeeAssets.helpers
      helpers.should =~ /foo/
    end
  end
end
