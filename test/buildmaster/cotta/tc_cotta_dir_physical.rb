$:.unshift File.join(File.dirname(__FILE__))

require 'cotta_dir_behaviors'
require 'physical_system_stub'

require 'spec'

module BuildMaster
describe PhysicalSystem, 'work with CottaDir' do
  it_should_behave_like 'CottaDirBehaviors'

  def create_system
    @system = PhysicalSystemStub.new
  end
  
end
end

$:.shift