module BuildMaster
class SvnAdminDriver
  def initialize(path)
    @path = path
    @cotta = Cotta.new
  end
  
  def create
    repository = "file:///#{@path}"
    @cotta.shell("svnadmin create #{@path}")
    @cotta.shell("svn mkdir #{repository}/trunk -m \"creating trunk directory\"")
    @cotta.shell("svn mkdir #{repository}/tags -m \"creating tags directory\"")
    @cotta.shell("svn mkdir #{repository}/branches -m \"creating branches directory\"")
  end
end
end