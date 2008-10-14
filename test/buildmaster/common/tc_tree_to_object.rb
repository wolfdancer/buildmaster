require 'spec'

require File.dirname(__FILE__) + '/../../../lib/buildmaster/common/tree_to_object'

module BuildMaster

class SampleObject
  attr_reader :field_one, :field_two, :object_two, :array_field
  attr_writer :field_one, :field_two
  
  def initialize
    @object_two = SampleTwo.new
    @array_field = Array.new
  end

  def add_to_array_field
    item = SampleTwo.new
    @array_field.push(item)
    return item
  end
end

class SampleTwo
  attr_reader :field, :index
  attr_writer :field, :index
end

describe TreeToObject do
  it 'should_populate_string_fields' do
    content = <<CONTENT
field_one: value_one
field_two: value_two
CONTENT
    tree = YAML.load(content)
    object = SampleObject.new
    TreeToObject.new(tree, object).convert
    object.field_one.should == 'value_one'
    object.field_two.should == 'value_two'
  end

  it 'should_populate_array_fields' do
    content = <<CONTENT
array_field:
- field: valueone
  index: 1
- field: valuetwo
  index: 2
CONTENT
    object = TreeToObject.from_yaml(content, SampleObject.new)
    array = object.array_field
    array.size.should == 2
    array[0].field.should == 'valueone'
    array[0].index.to_s.should == '1'
    array[1].field.should == 'valuetwo'
    array[1].index.to_s.should == '2'
  end

  it 'should_populate_instance_fields' do
    content = <<CONTENT
object_two:
  field: my_field
  index: 5
CONTENT
    object = TreeToObject.from_yaml(content, SampleObject.new)
    actual = object.object_two
    actual.field.should == 'my_field'
    actual.index.to_s.should == '5'
  end

  it 'should_raise_error_if_property_not_found' do
    content = <<CONTENT
not_field: value
CONTENT
    begin
      object = TreeToObject.from_yaml(content, SampleObject.new)
      fail('exception should have been thrown')
    rescue PropertyMatchError => error
      error.message.include?('not_field').should == true
      error.message.include?('string').should == true
    end
  end
  
  it 'should_raise_error_if_sub_property_not_found' do
    content = <<CONTENT
not_sub_property:
  field: value
CONTENT
    begin
      object = TreeToObject.from_yaml(content, SampleObject.new)
      fail('exception should have been thrown')
    rescue PropertyMatchError => error
      error.message.include?('not_sub_property').should == true    
      error.message.include?('sub property').should == true
    end
  end
  
  it 'should_raise_error_if_array_property_not_found' do
    content = <<CONTENT
not_array_property:
- name: title
- name: title
CONTENT
    begin
      object = TreeToObject.from_yaml(content, SampleObject.new)
      fail('exception should have been thrown')
    rescue PropertyMatchError => error
      error.message.include?('not_array_property').should == true
      error.message.include?('array').should == true
    end
  end
  
  it 'empty_content' do
    object = TreeToObject.from_yaml('', SampleObject.new)
    object.field_one.should == nil
  end

end

end
