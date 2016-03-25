require 'spec_helper'
require 'rails/all'

describe HamlCoffeeAssets do

  def init_rails_app
    Class.new(Rails::Application) do
      # Rails 4 requires application class to have name
      def self.name
        'Dummy'
      end

      config.active_support.deprecation = :stderr
      config.eager_load = false

      config.logger = Logger.new('/dev/null')

      config.assets.tap do |assets|
        assets.enabled = true
        assets.version = '1.0'
        assets.cache_store = :null_store
        assets.paths = [ File.expand_path("../support", __FILE__) ]
        assets.delete(:compress)
      end

      yield config if block_given?
    end.initialize!
  end

  after(:each) do
    Rails.application = nil
  end

  it 'adds hamlc files into assets pipeline' do
    asset = init_rails_app.assets.find_asset('test')
    expect(asset).not_to be_nil
    expect(asset.pathname.basename.to_s).to eq 'test.hamlc'
  end
end
