$:.unshift File.dirname(__FILE__)

require 'common_templatelet_test'

module BuildMaster
describe 'TextTest' do
  include HelperMethods
  before do
    setup_spec
  end

  it 'should_generate_text_based_on_property' do
    target = create_element('target')
    template = create_element('text')
    template.attributes['property'] = 'property'
    text = Text.new({'property' => 'text'})
    text.process(target, template, nil)
    target.text.should == 'text'
  end
  
  it 'should_throw_exception_if_property_not_set' do
    target = create_element('target')
    template = create_element('text')
    template.attributes['property'] = 'one'
    text = Text.new(Hash.new)
    begin
      text.process(target, template, nil)
      fail('TemplateError should have been thrown')
    rescue TemplateError => exception
      exception.message.include?('one').should == true
    end
  end
end
end