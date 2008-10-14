dir = File.dirname(__FILE__)
require dir + '/../test'
require dir + '/common_templatelet_test'

module BuildMaster

class AttributeForTest
  def initialize(logger)
    @logger = logger
  end

  def expression(path)
    @logger.expression_called_with(path)
    return 'value'
  end
end

describe Attribute do
  include HelperMethods
  
  before do
    setup_spec
  end
  
  it 'should_set_attribute_based_on_evaluation' do
    templatelet = Attribute.new(AttributeForTest.new(self))
    target = create_element('a')
    template_element = create_attribute_element('attr-name', 'expression')
    expected_pathname = Pathname.new('/path')
    @source_path = SourceContent.new(expected_pathname, nil, nil)
    templatelet.process(target, template_element, @source_path)
    target.attributes['attr-name'].should == 'value'
    @path_logged.path.should == expected_pathname
  end
  
  it 'should_check_for_expression_responder' do
    target = create_element('a')
    template_element = create_attribute_element('name', 'eval')
    source_path = SourceContent.new(Pathname.new('./'), create_element('name'), nil)
    attribute = Attribute.new(self)
    Proc.new {attribute.process(target, template_element, source_path)}.should raise_error(TemplateError)
  end
  
  it 'shoul check properties as a backup' do
    target = create_element('a')
    template_element = create_attribute_element('name', 'property')
    source_path = SourceContent.new(Pathname.new('./'), create_element('name'), nil)
    attribute = Attribute.new(self, {'property' => 'value'})
    attribute.process(target, template_element, @source_path)
    target.attributes['name'].should == 'value'
  end
  
  def create_attribute_element(name, eval)
    element = create_element('attribute')
    element.attributes['name'] = name
    element.attributes['eval'] = eval
    return element
  end
  
  def expression_called_with(path)
    @path_logged = path
  end
end
end
