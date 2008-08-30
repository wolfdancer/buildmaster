$:.unshift File.dirname(__FILE__)

require 'spec'
require 'cotta_file_behaviors'

$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'buildmaster')

require 'cotta/in_memory_system'

module BuildMaster
  describe InMemorySystem, 'with cotta file' do
    it_should_behave_like 'CottaFileBehaviors'

    def create_system
      @system = InMemorySystem.new
    end

  end
end

$:.shift