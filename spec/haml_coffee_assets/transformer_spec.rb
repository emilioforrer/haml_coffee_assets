require 'spec_helper'

describe HamlCoffeeAssets::Transformer do
  before do
    HamlCoffeeAssets.instance_variable_set '@config', HamlCoffeeAssets::Configuration.new
  end

  describe '#evaluate' do
    context 'for a JST template' do
      let(:transformer) do
        HamlCoffeeAssets::Transformer.new('templates/foo/bar.jst.hamlc') { |t| '%h2' }
      end

      it 'does not filter the template name' do
        expect(HamlCoffeeAssets::Compiler).to receive(:compile).with('templates/foo/bar.jst.hamlc', '%h2', false)
        transformer.render(nil, {})
      end
    end

    context 'for a HAMLC template' do
      context 'with the default name filter' do
        context 'with a template that matches' do
          let(:transformer) do
            HamlCoffeeAssets::Transformer.new('templates/foo/bar.hamlc') { |t| '%h2' }
          end

          it 'does filter the template directory' do
            expect(HamlCoffeeAssets::Compiler).to receive(:compile).with('foo/bar.hamlc', '%h2', true)
            transformer.render(nil, {})
          end
        end

        context 'with a template that does matches' do
          let(:transformer) do
            HamlCoffeeAssets::Transformer.new('other/templates/foo/bar.hamlc') { |t| '%h2' }
          end

          it 'does not filter the template directory' do
            expect(HamlCoffeeAssets::Compiler).to receive(:compile).with('other/templates/foo/bar.hamlc', '%h2', true)
            transformer.render(nil, {})
          end
        end
      end

      context 'with a custom name filter' do
        before { HamlCoffeeAssets.config.name_filter = lambda { |n| n.sub /^other\/templates\//, '' } }

        context 'with a template that matches' do
          let(:transformer) do
            HamlCoffeeAssets::Transformer.new('other/templates/foo/bar.hamlc') { |t| '%h2' }
          end

          it 'does filter the template directory' do
            expect(HamlCoffeeAssets::Compiler).to receive(:compile).with('foo/bar.hamlc', '%h2', true)
            transformer.render(nil, {})
          end
        end

        context 'with a template that does matches' do
          let(:transformer) do
            HamlCoffeeAssets::Transformer.new('templates/foo/bar.hamlc') { |t| '%h2' }
          end

          it 'does not filter the template directory' do
            expect(HamlCoffeeAssets::Compiler).to receive(:compile).with('templates/foo/bar.hamlc', '%h2', true)
            transformer.render(nil, {})
          end
        end
      end

      context 'without a name filter' do
        let(:transformer) do
          HamlCoffeeAssets::Transformer.new('templates/foo/bar.hamlc') { |t| '%h2' }
        end

        before { HamlCoffeeAssets.config.name_filter = nil }

        it 'does not filter the template name' do
          expect(HamlCoffeeAssets::Compiler).to receive(:compile).with('templates/foo/bar.hamlc', '%h2', true)
          transformer.render(nil, {})
        end
      end
    end
  end
end
