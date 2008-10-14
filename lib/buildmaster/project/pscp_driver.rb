module BuildMaster
class PscpDriver
  def initialize(server_url, cotta = Cotta.new())
    @server_url = server_url
    @cotta = cotta
  end
  
  def copy(source, target)
    @cotta.shell("pscp -r #{source} #{@server_url}:#{target}")
  end
end
end