require 'spec_helper'

describe HamlCoffeeAssets do
  describe '.config' do
    it 'returns the configuration object' do
      HamlCoffeeAssets.config.should be_an_instance_of ::HamlCoffeeAssets::Configuration
    end
  end

  describe '.helpers' do
    context 'with compilation enabled' do
      it 'returns the helpers as JavaScript' do
        helpers = HamlCoffeeAssets.helpers
        helpers.should =~ /HAML.escape/
        helpers.should =~ /HAML.cleanValue/
        helpers.should =~ /HAML.extend/
        helpers.should =~ /HAML.globals/
        helpers.should =~ /HAML.context/
        helpers.should =~ /HAML.preserve/
        helpers.should =~ /HAML.findAndPreserve/
        helpers.should =~ /HAML.surround/
        helpers.should =~ /HAML.succeed/
        helpers.should =~ /HAML.precede/
      end
    end

    context 'with compilation disabled' do
      it 'returns the helpers as CoffeeScript' do
        helpers = HamlCoffeeAssets.helpers(false)
        helpers.should =~ /@escape/
        helpers.should =~ /@cleanValue/
        helpers.should =~ /@extend/
        helpers.should =~ /@globals/
        helpers.should =~ /@context/
        helpers.should =~ /@preserve/
        helpers.should =~ /@findAndPreserve/
        helpers.should =~ /@surround/
        helpers.should =~ /@succeed/
        helpers.should =~ /@precede/
      end
    end
  end
end
