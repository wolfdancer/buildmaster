require 'spec'
require 'rexml/element'
require File.dirname(__FILE__) + '/test'

module BuildMaster
describe 'element processor by element name' do
  it 'should raise exception if not configured for template' do
    processor = ElementProcessorByName.new(Hash.new)
    target = REXML::Element.new
    element = REXML::Element.new('name')
    Proc.new {processor.process(target, element, SourceContent.new(nil, nil, nil))}.should raise_error(TemplateError)
  end
  
  it 'should process' do
    target = REXML::Element.new
    element = REXML::Element.new('name')
    source = SourceContent.new(nil, nil, nil)
    templatelet_mock = mock('templatelet for name')
    templatelet_mock.should_receive(:process).with(target, element, source).once
    hash = Hash.new
    hash['name'] = templatelet_mock
    ElementProcessorByName.new(hash).process(target, element, source)
  end
  
end
end