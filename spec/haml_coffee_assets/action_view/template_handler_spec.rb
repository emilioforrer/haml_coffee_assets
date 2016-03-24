require 'spec_helper'
require 'action_view'
require 'haml_coffee_assets/action_view/template_handler'

describe HamlCoffeeAssets::ActionView::TemplateHandler do
  def new_template(body)
    ::ActionView::Template.new(
      body,
      "template",
      described_class,
      virtual_path: "path/to/_template"
    )
  end

  let(:context) { Object.new }
  let(:locals) { Hash.new }

  let(:global_context) do
    path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'support', 'hamlcoffee_baseline.js'))
    File.read(path)
  end

  before do
    allow(HamlCoffeeAssets::GlobalContext).to receive(:to_s) { global_context }
  end

  it "renders basic templates" do
    output = new_template("Foo").render(context, locals)
    expect(output).to eq "Foo"
  end

  it "renders Haml" do
    output = new_template("%h1 Foo").render(context, locals)
    expect(output).to eq "<h1>Foo</h1>"
  end

  it "renders CoffeeScript" do
    output = new_template("= @foo").render(context, foo: "Foo")
    expect(output).to eq "Foo"
  end

  describe "partial rendering" do
    let(:basic_partial) { "= @foo" }
    let(:nested_partial) { "!= JST['basic/partial'](foo: @foo)" }

    def stub_partial_source
      allow_any_instance_of(described_class).to receive(:partial_source)
    end

    before do
      stub_partial_source.with("basic/partial") { basic_partial }
      stub_partial_source.with("basic_partial_01") { basic_partial }
      stub_partial_source.with("nested/partial") { nested_partial }
    end

    it "renders partials with bracket notation" do
      template = new_template("!= window.JST['basic/partial'](foo: 'Foo')")
      output = template.render(context, foo: "Foo")
      expect(output).to eq "Foo"
    end

    it "renders partials with dot notation" do
      template = new_template("!= window.JST.basic_partial_01(foo: 'Foo')")
      output = template.render(context, foo: "Foo")
      expect(output).to eq "Foo"
    end

    it "doesn't require JST to be called on window" do
      template = new_template("!= JST['basic/partial'](foo: 'Foo')")
      output = template.render(context, foo: "Foo")
      expect(output).to eq "Foo"
    end

    it "renders nested templates" do
      template = new_template("!= JST['nested/partial'](foo: 'Foo')")
      output = template.render(context, foo: "Foo")
      expect(output).to eq "Foo"
    end

    it "doesn't include the same partial dependency more than once" do
      template = new_template(
        "!= JST['nested/partial'](foo: @foo)\n#{nested_partial}"
      )

      compiled = described_class.new(template).send(:compilation_string)
      expect(compiled.scan(/JST\['basic\/partial'\] =/).size).to eq 1

      output = template.render(context, foo: "Foo")
      expect(output).to eq "Foo\nFoo"
    end
  end
end
