$:.unshift File.dirname(__FILE__)
require 'templatelets/common_templatelet_test'

$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib', 'buildmaster')

require 'templatelets'
require 'rexml/element'
require 'spec'

module BuildMaster

describe 'element class alternation' do
  include HelperMethods
  
  it 'get attribute value' do
    content = <<CONTENT
<root>
  <element name="value"/>
</root>
CONTENT
    element = create_template_element(content, 'root/element')
    element.attribute_value('name').should == 'value'
  end
  
  it 'raise template error if value is not there' do
    content = <<CONTENT
<root>
  <element/>
</root>
CONTENT
    element = create_template_element(content, 'root/element')
    Proc.new{element.attribute_value!('name')}.should raise_error(TemplateError)
  end
end
    

end