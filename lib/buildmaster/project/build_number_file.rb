
module BuildMaster
class BuildNumberFile
  attr_reader :number
  
  def initialize(path)
    @path = path
    @number = @path.load().strip.to_i
  end
  
  def increase_build
    @number = @number + 1
    @path.save(@number)
  end
  
  def to_s
    number
  end
  
end
end