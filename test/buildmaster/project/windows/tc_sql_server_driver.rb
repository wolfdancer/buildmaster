$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'buildmaster')

require 'spec'
require 'windows/sql_server_driver'
require 'cotta'
require 'cotta/in_memory_system'

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