module BuildMaster

class ElementProcessorByName
  def initialize(templatelets)
    @templatelets = templatelets
  end
  
  def process(target_element, template_element, source_instance)
    templatelet = @templatelets[template_element.name]
    raise TemplateError.new(template_element), "Cannot process element by name #{template_element.name}" unless templatelet
    templatelet.process(target_element, template_element, source_instance)
  end
end
end