$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'buildmaster')

require 'spec'

require 'project/build_number_file'
require 'cotta'
require 'cotta/in_memory_system'

module BuildMaster
describe BuildNumberFile do
  before do
    @cotta = Cotta.new(InMemorySystem.new)
  end
  
  after do
    @cotta = nil
  end
  
  it 'load_file' do
    path = @cotta.file('tmp/buildnumber')
    path.save(2)
    build_number = BuildNumberFile.new(path)
    build_number.number.should == 2
  end
  
  it 'increase_build' do
    path = @cotta.file('tmp/buildnumber')
    path.save(3)
    build_number = BuildNumberFile.new(path)
    build_number.increase_build
    build_number.number.should == 4
    reloaded = BuildNumberFile.new(path)
    reloaded.number.should == 4
  end
end
end