module BuildMaster
class Attribute
  def initialize(expression_evaluator, properties = {})
    @evaluator = expression_evaluator
    @properties = properties
  end
  
  def process(target, template, source)
    name = template.attribute_value!('name')
    eval = template.attribute_value!('eval')
    result = nil
    if (@evaluator.respond_to?(eval))
      result = @evaluator.send(eval, source)
    else
      result = @properties[eval]
      raise TemplateError.new(template), '#{@evaluator.class} cannot evaluate expression #{eval}' unless result
    end
    target.attributes[name] = result
  end
end
end