require 'yaml'

module BuildMaster

class PropertyMatchError < StandardError
  
  attr_reader :property, :type, :target

  def initialize(property, type, target)
    @property = property
    @type = type
    @target = target
  end
end

class TreeToObject
  def initialize(tree, object)
    @tree = tree
    @object = object
  end

  def TreeToObject.from_yaml(content, object)
    tree = {}
    if (content.chomp!)
      tree = YAML.load(content)
     if (not tree.kind_of?(Hash))
       raise "Format error for content:\n#{content}"
     end
   end
    return TreeToObject.new(tree, object).convert
  end


  def convert
    @tree.each_pair do |key, value|
      if (value.kind_of?(Array))
        convert_array(key, value)
      elsif (value.kind_of?(Hash))
        convert_hash(key, value)
      else
        convert_property(key, value)
      end
    end
    return @object
  end

  private
  def convert_hash(field, hash)
    return TreeToObject.new(hash, property("#{field}", field, 'sub property')).convert
  end

  def convert_array(field, array)
    array.each do |item|
      TreeToObject.new(item, property("add_to_#{field}", field, 'array')).convert
    end
  end
  
  def convert_property(field, value)
    method = "#{field}="
    check_property(method, field, 'string')
    @object.send("#{field}=", value)
  end  
  
  def property(method, field, type)
    check_property(method, field, type)
    @object.send(method)
  end
  
  def check_property(method, field, type)
    if not @object.respond_to? method
      message = "#{field} does not exist as #{type} in #{@object}"
      raise PropertyMatchError.new(field, type, @object), message, caller
    end
  end
end
end
