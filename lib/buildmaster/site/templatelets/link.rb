require 'rexml/element'

module BuildMaster
class Link
  def initialize(site_spec)
    @site_spec = site_spec
  end

  def process(target, template, source)
    target_path = get_href_as_relative_path(template)
    result = nil
    if (target_path == source.path)
      result = REXML::Element.new('div')
      result.attributes['class'] = 'current'
    else
      result = REXML::Element.new('a')
      href = target_path.relative_path_from(source.path.parent)
     result.attributes['href'] = href.to_s
    end
    template.attributes.each do |name, value|
      result.attributes[name] = value unless name == 'href'
    end
    template.each_child do |element|
      runner = TemplateRunner.new(result, @site_spec.load_element_processor, source)
      runner.process template
    end
    target.add(result)
  end
  
  private
  def get_href_as_relative_path(template)
    href = Pathname.new(template.attribute_value!('href'))
    if (href.absolute?)
      href = href.relative_path_from(Pathname.new('/'))
    end
    return href
  end
  
end
end