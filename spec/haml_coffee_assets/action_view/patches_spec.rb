require 'spec_helper'

describe HamlCoffeeAssets::ActionView::Patches do
  class TemplateMock
    attr_reader :source, :handle_render_error

    def encode!
      # only Rails >= 3.2.0
    end

    include HamlCoffeeAssets::ActionView::Patches
  end

  let(:template) { TemplateMock.new }
  let(:view) { double(:view, :lookup_context => nil, :assigns => { :somekey => :somevalue }) }
  let(:error) { StandardError.new }

  before do
    allow(ActionView::Template::Error).to receive(:new)
    allow(template).to receive(:refresh) { template }
    allow(template).to receive(:raise)
  end

  describe "#handle_render_error" do
    after do
      template.handle_render_error view, error
    end

    context "Rails < 3.2.0" do
      before do
        stub_const("Rails::VERSION::STRING", "3.1.12")
        allow(template).to receive(:respond_to?) { false }
      end

      it "should #refresh template" do
        expect(template).to receive(:refresh).with(view)
      end

      it "shouldn't #encode! template" do
        expect(template).not_to receive(:encode!)
      end

      it "should raise an error" do
        expect(ActionView::Template::Error).to receive(:new).with(template, { :somekey => :somevalue }, error).and_return("An Error #1")
        expect(template).to receive(:raise).with("An Error #1")
      end
    end

    context "Rails >= 3.2.0" do
      before do
        stub_const("Rails::VERSION::STRING", "4.1.4")
      end

      it "should #refresh template" do
        expect(template).to receive(:refresh).with(view)
      end

      it "should #encode! template" do
        expect(template).to receive(:encode!)
      end

      it "should raise an error" do
        expect(ActionView::Template::Error).to receive(:new).with(template, error).and_return("An Error #2")
        expect(template).to receive(:raise).with("An Error #2")
      end
    end

    context "Rails >= 5.1.0" do
      before do
        stub_const("Rails::VERSION::STRING", "5.1.1")
      end

      it "should #refresh template" do
        expect(template).to receive(:refresh).with(view)
      end

      it "should #encode! template" do
        expect(template).to receive(:encode!)
      end

      it "should raise an error" do
        expect(ActionView::Template::Error).to receive(:new).with(template).and_return("An Error #3")
        expect(template).to receive(:raise).with("An Error #3")
      end
    end
  end
end
