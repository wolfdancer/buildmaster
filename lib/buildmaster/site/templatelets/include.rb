
module BuildMaster
class Include
  def initialize(site_spec)  
    @site_spec = site_spec
  end
  
  def process(target, template, source)
      elements_xpath = template.attribute_value!('elements')
      if (elements_xpath[elements_xpath.length - 1, 1] == '*')
        elements_xpath = elements_xpath[0, elements_xpath.length - 1]
        REXML::XPath.each(source.document, elements_xpath) do |matched|
          matched.each_child {|child| target.add(deep_clone(child))}
        end
      else
        REXML::XPath.each(source.document, elements_xpath) {|matched| target.add(deep_clone(matched))}
      end
  end
  
  private  
  def deep_clone(node )
    if node.kind_of? REXML::Parent
      node.deep_clone
    else
      node.clone
    end
  end
        
end
end