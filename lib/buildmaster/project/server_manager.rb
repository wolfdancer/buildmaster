
module BuildMaster
class ServerManager
  attr_reader :status
  
  def initialize(server)
    @server = server
    @status = 'stopped'
  end
  
  def start
    starting_server
    wait_for_condition {@server.running?}
    @status = 'started'
  end
  
  def stop
    stopping_server
    wait_for_condition {not @server.running?}
    @status = 'stopped'
  end

  private
  def starting_server
    @status = 'starting'
    ['INT', 'TERM'].each { |signal|
         trap(signal){ @server.stop} 
    }  
    start_thread {@server.start}
  end
  
  def stopping_server
    @status = 'stopping'
    start_thread {@server.stop}
  end
  
  def start_thread
    Thread.new do
      begin
        yield
      rescue Exception => exception
        @exception = exception
      end
    end
  end
  
  def wait_for_condition
    count = 0
    sleep 1
    while not (result = yield)
      if (@exception)
        error = @exception
        @exception = nil
        @status = 'error'
        raise error
      end
      count = count + 1
      raise 'wait timed out' unless count < 10
      sleep 1
    end
  end

end
end