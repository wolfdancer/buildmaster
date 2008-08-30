module BuildMaster

class CvsInfo  
  attr_reader :root, :repository

  public
  def initialize(root, repository)
    @root = root
    @repository = repository
  end
  
  def CvsInfo.load(folder)
    return CvsInfo.new(folder.file('ROOT').load.strip,  folder.file('Repository').load.strip)
  end
  
end

class CvsDriver
  def CvsDriver.from_path(working_directory)
    return CvsDriver.new(CvsInfo.load("#{working_directory}/CVS"), working_directory)
  end
  
  def initialize(cvs_info, working_directory)
    @cvs_info = cvs_info
    @working_directory = working_directory
    @cotta = @working_directory.cotta
  end
  
  def command(command)
    @cotta.shell "cvs -d #{@cvs_info.root} #{command} #{@working_directory.path}"
  end
  
  def checkout()
    @cotta.shell("cvs -d #{@cvs_info.root} co -d #{@working_directory.path} #{@cvs_info.repository}")
  end
  
  def update(option='')
    if (option.length > 0)
      option = ' ' + option
    end
    command("update#{option}")
  end
  
  def tag(name)
    command("tag #{name}")
  end
  
  def commit(comment)
    command("commit -m \"#{comment}\"")
  end
end

end