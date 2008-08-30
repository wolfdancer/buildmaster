require 'uri'
require 'open-uri'

module BuildMaster
class Each
  def initialize(site_spec)
    @site_spec = site_spec
  end
  
  def process(target, template, source)
      source_xml = load_source_xml(template)
      matched_element = REXML::XPath.match(source_xml, template.attribute_value!('select'))
      count = template.attribute_value!('count').to_i
      if (count > matched_element.size)
        count = matched_element.size
      end
      count.to_i.times do |i|
        element_source = SourceContent.new(source.path, matched_element[i], source.file)
        template_runner = TemplateRunner.new(target, @site_spec.load_element_processor, element_source)
        template_runner.process template
      end
  end
  
  private
  def load_source_xml(template)
    path = template.attribute_value!('source')
    if (URI.parse(path).scheme.nil?)
      return @site_spec.load_document(path)
    end
    return load_content_through_uri(path)
  end
  
  def load_content_through_uri(uri)
    buffer = StringIO.new
    begin
      open(uri) do |file|
        buffer.puts file.gets
      end
      return REXML::Document.new(buffer.string)
    rescue Exception => exception
      raise RuntimeError, "Error loading uri: #{uri}", caller
    end
  end
end
end