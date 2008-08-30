$:.unshift File.dirname(__FILE__)

require 'common_templatelet_test'

module BuildMaster
describe 'LinkTest' do
  include HelperMethods
  
  before do
    setup_spec
  end

  it 'should_generate_link_with_relative_path' do
    target = create_element('div')
    template_content = <<CONTENT
<?xml ?>
<root>
  <link href="content/path.html">text</link>
</root>
CONTENT
    template_document = REXML::Document.new(template_content)
    template = REXML::XPath.first(template_document, '/root/link')
    source = create_element('source')
    link = Link.new(SiteSpec.new)
    link.process(target, template, SourceContent.new(Pathname.new('doc/doc.html'), source, nil))
    actual = REXML::XPath.first(target, 'a')
    actual.attributes['href'].should == '../content/path.html'
    actual.text.should == 'text'
  end
  
  it 'should_copy_all_attributes' do
    target = create_element('div')
    template = create_element('link')
    template.attributes['href'] = 'content/path.html'
    template.attributes['attribute1'] = 'value1'
    template.attributes['attribute2'] = 'value2'
    source = create_element('source')
    link = Link.new(SiteSpec.new)
    link.process(target, template, SourceContent.new(Pathname.new('doc/doc.html'), source, nil))
    actual = REXML::XPath.first(target, 'a')
    actual.attributes['attribute1'].should == 'value1'
    actual.attributes['attribute2'].should == 'value2'
  end
  
  it 'should_handle_absolute_path' do
    target = create_element('div')
    template = create_element('link')
    template.attributes['href'] = '/content/path.html'
    source = create_element('source')
    link = Link.new(SiteSpec.new)
    link.process(target, template, SourceContent.new(Pathname.new('doc/iste/doc.html'), source, nil))
    actual = REXML::XPath.first(target, 'a')
    actual.attributes['href'].should == '../../content/path.html'
  end
  
  it 'should_generate_div_with_current_class_attribute_if_link_is_on_current_page' do
    target = create_element('div')
    template = create_element('link')
    template.attributes['href'] = '/content/path.html'
    source = create_element('source')
    link = Link.new(SiteSpec.new)
    link.process(target, template, SourceContent.new(Pathname.new('content/path.html'), source, nil))
    actual = REXML::XPath.first(target, 'div')
    actual.attributes['href'].should == nil
    actual.attributes['class'].should == 'current'
  end
  
end
end