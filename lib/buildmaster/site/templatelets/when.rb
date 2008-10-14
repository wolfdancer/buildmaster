module BuildMaster
class When
  def initialize(site_spec, expression_evaluator)
    @site_spec = site_spec
    @evaluator = expression_evaluator
  end
  
  def process(target, template, source)
    eval = template.attribute_value!('test')
    raise TemplateError.new(template), "#{@evaluator.class} cannot evaluate expression #{eval}" unless @evaluator.respond_to?(eval)
    if (@evaluator.send(eval, source))
      runner = TemplateRunner.new(target, @site_spec.load_element_processor, source)
      runner.process template
    end
  end
end
end