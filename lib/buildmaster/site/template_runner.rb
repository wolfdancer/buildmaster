$:.unshift File.dirname(__FILE__)

require 'site/template_error'

module BuildMaster
  class TemplateRunner
    @@NAMESPACE = 'http://buildmaster.rubyforge.org/xtemplate/1.0'

    def initialize(target, template_element_processor, source)
      @target = target
      @template_element_processor = template_element_processor
      @source_instance = source
    end
        
    def process(teamplte)
      process_children(@target, teamplte)
    end
        
    private
    def process_children(target, template)
      template.each do |element|
        if (element.kind_of? REXML::Element)
          process_element(target, element)
        else
          target.add(deep_clone(element))
        end
      end
    end
        
    def process_element(target, element)
      if (template_directive?(element))
        process_directive(target, element)
      else
        output_element = clone_element(element)
        target.add(output_element)
        process_children(output_element, element)
      end
    end
        
    def template_directive?(element)
      element.namespace == @@NAMESPACE
    end
        
    def process_directive(target, template_element)
      @template_element_processor.process(target, template_element, @source_instance)
    end

    def clone_element( template_element )
      cloned_element = REXML::Element.new( template_element.expanded_name )
      copy_attributes( template_element, cloned_element )
      cloned_element
    end
        
    def copy_attributes( template_element, expanded_element )
      template_element.attributes.each_attribute do |attribute|
          expanded_element.attributes.add( attribute.clone )
      end
    end
        
    def deep_clone( node )
      if node.kind_of? REXML::Parent
        node.deep_clone
      else
        node.clone
      end
    end
        
  end
end
