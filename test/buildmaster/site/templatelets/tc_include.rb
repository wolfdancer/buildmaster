require 'spec'
require File.dirname(__FILE__) + '/../test'
require File.dirname(__FILE__) + '/common_templatelet_test'
module BuildMaster

describe 'IncludeTest' do
  include HelperMethods
  
  before do
    setup_spec
  end
  
  it 'should_include_the_source' do
    target = create_element('target')
    template = create_element('include')
    template.attributes['elements'] = '/item/*'
    source_content = <<CONTENT
<item>
  text
  <one>test</one>
  <two></two>
</item>
CONTENT
    source = SourceContent.new(Pathname.new('doc/index.html'), REXML::Document.new(source_content), nil)
    include = Include.new(SiteSpec.new)
    include.process(target, template, source)
    REXML::XPath.first(target, 'one').text.should == 'test'
    target.text.strip!.should == 'text'
  end
end
end

