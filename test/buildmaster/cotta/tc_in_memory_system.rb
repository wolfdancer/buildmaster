$:.unshift File.dirname(__FILE__)

require 'file_system_behaviors'
  
$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'buildmaster')

require 'cotta/in_memory_system'
require 'spec'

module BuildMaster

describe InMemorySystem do
  it_should_behave_like 'FileSystemBehaviors'

  def create_system
    @system = InMemorySystem.new
    @ios = Array.new
  end
  
  after do
    @ios.each {|io| io.close unless io.closed?}
  end
  
  it 'root directory always exists' do
    @system.dir_exists?(Pathname.new('/')).should == true
    @system.dir_exists?(Pathname.new('D:/')).should == true
  end
  
end
end