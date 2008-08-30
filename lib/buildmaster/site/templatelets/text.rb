module BuildMaster
class Text
  def initialize(properties)
    @properties = properties
  end
  
  def process(target, template, source)
      property = template.attribute_value!('property')
      value = @properties[property]
      raise TemplateError.new(template), "property value for '#{property}' not found" unless value
      target.add(REXML::Text.new(value))
  end
end
end