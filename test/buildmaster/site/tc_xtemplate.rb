$:.unshift File.join(File.dirname(__FILE__), "..", "..", "lib", 'buildmaster')

require 'rexml/xpath'
require 'spec'
require 'site/source_content'
require 'cotta'
require 'cotta/in_memory_system'

module BuildMaster

describe 'XTemplate' do
  before do
    @cotta = Cotta.new(InMemorySystem.new)
  end

  it 'should_initialize_with_io' do
    template_file = @cotta.file('template.xhtml')
    template_file.save <<CONTENT
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:template="http://buildmaster.rubyforge.org/xemplate/1.0">
  <head>
    <title>JBehave - <template:include elements="/html/head/title/text()"/></title>
    <template:include elements="/html/head/*[not(name()='title')]"/>
  </head>

  <body>
  </body>
</html>
CONTENT
    template = BuildMaster::XTemplate.new(REXML::Document.new(template_file.load), Hash.new)
  end
      
  it 'should_initialize_with_content' do
    template_content = <<CONTENT
<html xmlns="http://www.w3.org/1999/xhtml"
        xmlns:template="http://buildmaster.rubyforge.org/xtemplate/1.0">
    <head>
      <title>BuildMaster</title>
    </head>
    <body>Body</body>
  </html>
CONTENT
    template = XTemplate.new(REXML::Document.new(template_content), Hash.new)
    xml_output = template.process(SourceContent.new(Pathname.new('content'), nil, nil))
    REXML::XPath.first(xml_output, '/html/body').text.should == 'Body'
  end
      
  it 'should_hook_up_templatelets' do
    template_content = <<INCLUDE_CONTENT
<html xmlns="http://www.w3.org/1999/xhtml"
        xmlns:template="http://buildmaster.rubyforge.org/xtemplate/1.0">
    <head>
      <title>BuildMaster - <template:when test="index_file?">Index</template:when></title>
    </head>
    <body>
      <template:when test="what?">
      <ul>
        <li>one</li>
      </ul>
      </template:when>
    </body>
</html>
INCLUDE_CONTENT
    source_content = <<INCLUDE_SOURCE
<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head><title>Page Title</title></head>
  <body></body>
</html>
INCLUDE_SOURCE
    template = XTemplate.new(REXML::Document.new(template_content), load_element_processor)
    xml_document = template.process(SourceContent.new(nil, source_content, nil))
    xml_output = REXML::Document.new(xml_document.to_s())
    REXML::XPath.first(xml_output, '/html/head/title').text.should == 'BuildMaster - Index'
    REXML::XPath.first(xml_output, '/html/body/ul/li').text.should == 'one'
  end
      
  def what?(path)
    return true
  end
  
  def index_file?(path)
    return true
  end
  
  def load_element_processor
    ElementProcessorByName.new({'when' => When.new(self, self)})
  end
end
end
