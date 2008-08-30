module BuildMaster
class VersionNumberFile
  attr_reader :build_number
  
  def initialize(file)
    @file = file
    self.version= @file.load.strip
  end
  
  def increase_build
    @build_number = @build_number + 1
    @file.save("#{version_number}")
  end
  
  def version_number
    "#{@version_number}.#{@build_number}"
  end
  
  def version= (value)
    index = dot_position_for_buildnumber(value)
    @version_number = value
    @build_number = 0
    unless index.nil?
      @version_number = value[0..index - 1]
      @build_number = value[index + 1..value.length - 1].to_i
    end
  end
  
  def dot_position_for_buildnumber(value)
    splitted = value.split('.')
    result = nil
    if splitted.size > 2 && splitted[splitted.size - 1].length > 0
      result = value.length - splitted[splitted.size - 1].length - 1
    end
    return result
  end
  
  private :dot_position_for_buildnumber
  
  def to_s
    "#{version_number}.#{build_number}"
  end
  
end
end