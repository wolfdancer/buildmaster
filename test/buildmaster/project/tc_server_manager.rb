$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'buildmaster')

require 'project/server_manager'
require 'spec'


module BuildMaster
class StubServer
  def initialize
    @count = 0
  end
  
  def start
  end
  
  def stop
    @count = 0
  end
  
  def running?
    if (@count == 3)
      return true
    end
    @count = @count + 1
    return false
  end
end

describe ServerManager do
  it 'server manager default to stopped status' do
    ServerManager.new(mock('server')).status.should == 'stopped'
  end
  
  it 'launch server' do
    server = mock('server')
    server.should_receive(:start)
    server.should_receive(:running?).and_return(true)
    manager = ServerManager.new(server)
    manager.start
    manager.status.should == 'started'
  end
  
  it 'keep checking server to see if it is running' do
    manager = ServerManager.new(StubServer.new)
    manager.start
    manager.status.should == 'started'
  end
  
  it 'stop and wait until it is not runnig anymore' do
    manager = ServerManager.new(StubServer.new)
    manager.start
    manager.stop
    manager.status.should == 'stopped'
  end
  
  it 'raise error if start failed' do
    server = mock('server that fails on start')
    server.should_receive(:start).and_raise 'error'
    server.should_receive(:running?).any_number_of_times.and_return(false)
    manager = ServerManager.new(server)
    begin
      manager.start
      fail('should have raised error')
    rescue
    ensure
      manager.status.should == 'error'
    end
  end
end
end