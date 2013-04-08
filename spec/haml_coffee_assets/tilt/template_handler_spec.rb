require 'spec_helper'

describe HamlCoffeeAssets::Tilt::TemplateHandler do
  
  let(:template) { HamlCoffeeAssets::Tilt::TemplateHandler.new { |t| '%h2' } }

  before do
    HamlCoffeeAssets.instance_variable_set '@config', HamlCoffeeAssets::Configuration.new
  end

  describe '#evaluate' do
    context 'for a JST template' do
      let(:scope) do
        double('scope', {
          pathname: 'templates/foo/bar.jst.hamlc',
          logical_path: 'templates/foo/bar'
        })
      end

      it 'does not filter the template name' do
        HamlCoffeeAssets::Compiler.should_receive(:compile).with('templates/foo/bar', '%h2', false)
        template.render(scope)
      end
    end

    context 'for a HAMLC template' do
      context 'with the default name filter' do
        context 'with a template that matches' do
          let(:scope) do
            double('scope', {
              pathname: 'templates/foo/bar.hamlc',
              logical_path: 'templates/foo/bar'
            })
          end
  
          it 'does filter the template directory' do
            HamlCoffeeAssets::Compiler.should_receive(:compile).with('foo/bar', '%h2', true)
            template.render(scope)
          end
        end
  
        context 'with a template that does matches' do
          let(:scope) do
            double('scope', {
              pathname: 'other/templates/foo/bar.hamlc',
              logical_path: 'other/templates/foo/bar'
            })
          end
  
          it 'does not filter the template directory' do
            HamlCoffeeAssets::Compiler.should_receive(:compile).with('other/templates/foo/bar', '%h2', true)
            template.render(scope)
          end
        end
      end

      context 'with a custom name filter' do
        before { HamlCoffeeAssets.config.name_filter = lambda { |n| n.sub /^other\/templates\//, '' } }

        context 'with a template that matches' do
          let(:scope) do
            double('scope', {
              pathname: 'other/templates/foo/bar.hamlc',
              logical_path: 'other/templates/foo/bar'
            })
          end

          it 'does filter the template directory' do
            HamlCoffeeAssets::Compiler.should_receive(:compile).with('foo/bar', '%h2', true)
            template.render(scope)
          end
        end

        context 'with a template that does matches' do
          let(:scope) do
            double('scope', {
              pathname: 'templates/foo/bar.hamlc',
              logical_path: 'templates/foo/bar'
            })
          end

          it 'does not filter the template directory' do
            HamlCoffeeAssets::Compiler.should_receive(:compile).with('templates/foo/bar', '%h2', true)
            template.render(scope)
          end
        end
      end

      context 'without a name filter' do
        let(:scope) do
          double('scope', {
            pathname: 'templates/foo/bar.hamlc',
            logical_path: 'templates/foo/bar'
          })
        end

        before { HamlCoffeeAssets.config.name_filter = nil }
        
        it 'does not filter the template name' do
          HamlCoffeeAssets::Compiler.should_receive(:compile).with('templates/foo/bar', '%h2', true)
          template.render(scope)
        end
      end
    end
  end
end
