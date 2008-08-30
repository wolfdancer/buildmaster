module BuildMaster
class JavaManifest
  def initialize(manifest_file)
    @manifest_file = manifest_file
  end
  
  def JavaManifest::from_file(manifest_file)
    return JavaManifest.new(manifest_file)
  end
  
  def version
    number = nil
    build = nil
    @manifest_file.foreach do |line|
      name_value = NameValue.parse(line)
      if (name_value.name== "Implementation-Version")
        number = name_value.value
      elsif (name_value.name == "Implementation-Build")
        build = name_value.value
      end
    end
    return Version.new(number, build.to_i)
  end
  
  def increase_build
    content = ""
    number = nil
    build = nil
    @manifest_file.foreach do |line|
      name_value = NameValue.parse(line)
      if (name_value.name== "Implementation-Version")
        number = name_value.value
        content = content + line
      elsif (name_value.name == "Implementation-Build")
        build = name_value.value.to_i + 1
        content = content + "Implementation-Build: #{build}\n"
      else
        content = content + line
      end
    end
    @manifest_file.write do |file|
      file.printf(content)
    end
    return Version.new(number, build)
  end
end

class NameValue
  attr_reader :name, :value

  def NameValue.parse(line)
    name_value = NameValue.new(nil, nil)
    index = line.index(':')
    if (index)
      name=line[0, index]
      value=line[index+1, line.length].strip
      name_value = NameValue.new(name, value)
    end
    return name_value
  end
  
  def initialize(name, value)
    @name = name
    @value = value
  end
end

class Version
  attr_reader :number, :build
  
  def initialize(number, build) 
    @number = number
    @build = build
  end
end
end