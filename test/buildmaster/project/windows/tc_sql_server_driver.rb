require 'spec'
require File.dirname(__FILE__) + '/../../../../lib/buildmaster/windows'
require File.dirname(__FILE__) + '/../../../../lib/buildmaster/cotta'

module BuildMaster

describe 'Microsoft SQL server driver' do
  def setup
    @system = InMemorySystem.new
    @server = SqlServerDriver.new(Cotta.new(@system))
  end
  
  it 'should control sql server - but need SQL server installed and not running' do
    @server = SqlServerDriver.new
    @server.start
    @server.status
    @server.stop
  end
  
end
end