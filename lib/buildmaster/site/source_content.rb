module BuildMaster
class SourceContent
  attr_reader :path, :document, :file
  
  def initialize(path, document, file)
    @path = path
    @document = document
    @file = file
  end
  
end
end