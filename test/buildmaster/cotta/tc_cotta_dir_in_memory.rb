$:.unshift File.dirname(__FILE__)
require 'cotta_dir_behaviors'
$:.shift

$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'buildmaster')

require 'spec'
require 'cotta/in_memory_system'

module BuildMaster
  describe InMemorySystem, 'with Cotta Dir' do
    it_should_behave_like 'CottaDirBehaviors'

    def create_system
      @system = InMemorySystem.new
    end

    it 'dir should not be equal if system different' do
      (BuildMaster::CottaDir.new(InMemorySystem.new, Pathname.new('dir')) == @dir).should == false
    end

    it 'to_s and inspect' do
      file = CottaFile.new(@system, '/one/two/file.txt')
      "#{file.to_s}".should == '/one/two/file.txt'
    end

  end
end
$:.shift