$:.unshift File.dirname(__FILE__)

require 'rexml/document'
require 'template_runner'

module BuildMaster
  class XTemplate
    def initialize(template, element_processor)
      @template = template
      @element_processor = element_processor
    end
        
    def process(source)
      output_xml = process_xml(source)
      return output_xml
    end
        
    private
    def process_xml(source, &evaluator)
      output_xml = REXML::Document.new
      runner = TemplateRunner.new(output_xml, @element_processor, source)
      runner.process @template
      return output_xml
    end
  end
end
