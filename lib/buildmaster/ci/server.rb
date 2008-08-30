module BuildMaster
module CI

=begin rdoc
A CI (Continuous Integration) server that does the following loop
* check for modifications
* if modification set found, 
** update
** make
** publish (update site, email notification)
=end
class Server

  def initialize
    @modification_checker = Array.new
    @updator = Array.new
  end
  
  def serve
    pid = fork {start}
    if (pid)
      ['INT', 'TERM'].each { |signal|
           trap(signal){Process.kill('break', pid)} 
      }
    end
  end

  def start
    puts "server started"
    until @stopped
      if check_modifications
        build_loop
      end
      sleep 30
    end
  end
  
  def stop
    @stopped = true
    Thread.current.raise 'shutting down'
  end
  
  private
  def check_modifications
  end
  
  def build_loop
    update
    result = build
    publish(result)
  end
end

end
end