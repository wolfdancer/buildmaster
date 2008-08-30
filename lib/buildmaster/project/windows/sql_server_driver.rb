$:.unshift File.join(File.dirname(__FILE__), '..', 'cotta')
module BuildMaster

class SqlServerDriver
  def initialize(cotta=Cotta.new)
    @instance_name = 'MSSQLSERVER'
    @cotta = cotta
  end

  def start
    execute('start')
  end
  
  def status
    execute('query')
  end
  
  def stop
    execute('stop')
  end
  
  private
  def execute(command)
    @cotta.shell("sc #{command} #{@instance_name}")
  end    
end
end
