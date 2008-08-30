$:.unshift File.join(File.dirname(__FILE__), '..')

require '../cotta'
require '../cotta/in_memory_system'

module BuildMaster
class SvnServerDriver
  def initialize(server, repository)
    @server = server
    @repository = repository
    @cotta = @server.cotta
  end

  def start
    @cotta.shell("#{@server.path} -d -r #{@repository.path}")
  end
end
end