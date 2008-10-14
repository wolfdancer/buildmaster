require 'spec'
require File.dirname(__FILE__) + '/../test'

module BuildMaster
describe VersionNumberFile do
  before do
    @cotta = Cotta.new(InMemorySystem.new)
  end
  
  after do
    @cotta = nil
  end
  
  it 'load_file' do
    path = @cotta.file('tmp/versionnumber')
    path.save('1.5.50')
    version_number = VersionNumberFile.new(path)
    version_number.build_number.should == 50
    version_number.version_number.should == '1.5.50'
  end
  
  it 'increase_build' do
    path = @cotta.file('tmp/buildnumber')
    path.save('2.9.1')
    version_number = VersionNumberFile.new(path)
    version_number.increase_build
    version_number.build_number.should == 2
    version_number.version_number.should == '2.9.2'
    reloaded = VersionNumberFile.new(path)
    reloaded.build_number.should == 2
  end
  
  it 'handle file with only major and minor version number' do
    path = @cotta.file('tmp/version')
    path.save('2.2')
    version_number = VersionNumberFile.new(path)
    version_number.build_number.should == 0
    version_number.version_number.should == '2.2.0'
  end
end
end