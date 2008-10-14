dir = File.dirname(__FILE__) + '/templatelets'

require dir + '/href'
require dir + '/attribute'
require dir + '/each'
require dir + '/include'
require dir + '/link'
require dir + '/text'
require dir + '/when'
require dir + '/code'

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