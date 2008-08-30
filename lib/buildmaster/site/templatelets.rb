$:.unshift(File.dirname(__FILE__))

require 'templatelets/href'
require 'templatelets/attribute'
require 'templatelets/each'
require 'templatelets/include'
require 'templatelets/link'
require 'templatelets/text'
require 'templatelets/when'
require 'templatelets/code'
require 'site/template_error'

module REXML
class Element
  def attribute_value!(name)
    value = attribute_value(name)
    raise BuildMaster::TemplateError.new(self), "attribute #{name} not found" unless value
    return value
  end
  
  def attribute_value(name)
    return attributes[name]
  end
end
end