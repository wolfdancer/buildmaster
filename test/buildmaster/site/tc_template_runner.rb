require 'rexml/xpath'
require 'rexml/document'
require 'pathname'
require 'spec'
require File.dirname(__FILE__) + '/test'

module BuildMaster
class NameTemplatelet
  def initialize(logger)
    @logger = logger
  end
  
  def process(target, element, current_path)
    @logger.processed(target, element)
  end
end

describe 'TemplateRunnerTest' do
    before do
      @templatelets = Hash.new
    end
    
    it 'process_element_in_document' do
      target_content = <<END
<html>
  <h1/>
</html>
END
      template_content = <<END
<html xmlns="http://www.w3.org/1999/xhtml"
        xmlns:template="http://buildmaster.rubyforge.org/xtemplate/1.0">
<p>
  <template:include elements="./name/text()"/>
</p>      
</html>
END
      source_content = <<END
<persons>
  <person id="1"><name>Name One</name></person>
  <person id="2"><name>Name Two</name></person>
</persons>
END
      target_xml = REXML::Document.new(target_content)
      target_element = REXML::XPath.first(target_xml, '/html/h1')
      template_element = REXML::XPath.first(REXML::Document.new(template_content), "/html/p")
      source_xml = REXML::Document.new(source_content)
      source_element = REXML::XPath.first(source_xml, '/persons/person[@id="1"]')
      @templatelets['include'] = Include.new(self)
      runner = TemplateRunner.new(target_element, ElementProcessorByName.new(@templatelets), 
          SourceContent.new(Pathname.new('content'), source_element, nil))
      runner.process template_element
      REXML::XPath.first(REXML::Document.new(target_xml.to_s), '/html/h1/text()').value.strip.should == 'Name One'
    end
    
    it 'should_use_templatelet_based_on_name' do
      output = REXML::Document.new
      template_content = <<END
<html xmlns="http://www.w3.org/1999/xhtml"
        xmlns:template="http://buildmaster.rubyforge.org/xtemplate/1.0">
<p>
  <template:name attribute="value" attribute2="value2"/>
</p>      
</html>
END
      template_document = REXML::Document.new(template_content)
      @templatelets['name'] = NameTemplatelet.new(self)
      runner = TemplateRunner.new(output, ElementProcessorByName.new(@templatelets), 
          SourceContent.new(Pathname.new('content/index.textile'), REXML::Document.new, nil))
      runner.process template_document
      @element_target.name.should == 'p'
      @element_processed.name.should == 'name'
      @element_processed.attributes['attribute'].should == 'value'
      @element_processed.attributes['attribute2'].should == 'value2'
    end
    
    def processed(target, element)
      @element_target = target
      @element_processed = element
    end
  end
  
end
