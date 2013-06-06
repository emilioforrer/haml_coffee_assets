require 'spec_helper'

describe HamlCoffeeAssets do
  describe '.config' do
    it 'returns the configuration object' do
      HamlCoffeeAssets.config.should be_an_instance_of ::HamlCoffeeAssets::Configuration
    end
  end
end
