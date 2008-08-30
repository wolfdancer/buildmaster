require 'spec'
require 'rexml/document'
require 'rexml/xpath'

$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'lib', 'buildmaster')

require 'site/content_engine_repository'
require 'cotta'
require 'cotta/in_memory_system'

module BuildMaster
describe ContentEngineRepository do
  before do
    @cotta = Cotta.new(InMemorySystem.new)
  end
  
  it 'can get content engine based on the source file' do
    repository = ContentEngineRepository.new
    source = @cotta.file('content.textile')
    source.save(<<CONTENT)
---
Title
---
h1. header
CONTENT
    textile_engine = repository.for_source(source)
    html_content = textile_engine.convert_to_html(source.load)
    document = REXML::Document.new(html_content)
    REXML::XPath.first(document, '/html/body/h1').get_text.should == 'header'
  end
  
  it 'can get content engine based on the target file' do
    repository = ContentEngineRepository.new
    source = @cotta.file('content.markdown')
    source.save(<<CONTENT)
---
Title
---
header
====================
CONTENT
    actual, markdown_engine = repository.for_candidate(source.parent, 'content')
    actual.path.should == source.path
    document = REXML::Document.new(markdown_engine.convert_to_html(source.load))
    REXML::XPath.first(document, '/html/body/h1').get_text.should == 'header'
  end
  
  it 'default format for txt file to textile' do
    repository = ContentEngineRepository.new
    source = @cotta.file('content.txt')
    source.save(<<CONTENT)
---
Title
---
h1. header
CONTENT
    textile_engine = repository.for_source(source)
    html_content = textile_engine.convert_to_html(source.load)
    document = REXML::Document.new(html_content)
    REXML::XPath.first(document, '/html/body/h1').get_text.should == 'header'
  end
end
end