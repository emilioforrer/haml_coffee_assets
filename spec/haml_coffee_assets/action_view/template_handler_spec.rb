require 'spec_helper'
require 'action_view'
require 'active_support/core_ext/object/to_json'
require 'haml_coffee_assets/action_view/template_handler'

describe HamlCoffeeAssets::ActionView::TemplateHandler do
  def new_template(body)
    ::ActionView::Template.new(
      body,
      "template",
      described_class,
      :virtual_path => "path/to/_template"
    )
  end

  let(:context) { Object.new }
  let(:locals) { Hash.new }

  it "renders basic templates" do
    output = new_template("Foo").render(context, locals)
    output.should == "Foo"
  end

  it "renders Haml" do
    output = new_template("%h1 Foo").render(context, locals)
    output.should == "<h1>Foo</h1>"
  end

  it "renders CoffeeScript" do
    output = new_template("= @foo").render(context, :foo => "Foo")
    output.should == "Foo"
  end

  it "has access to the helpers" do
    template = new_template("!= surround '(', ')', ->\n  %span Foo")
    output = template.render(context, locals)
    output.should == "(<span>Foo</span>)"
  end
end
