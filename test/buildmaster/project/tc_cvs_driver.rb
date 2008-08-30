$:.unshift File.join(File.dirname(__FILE__), "..", "..", '..', "lib", 'buildmaster')

require 'spec'
require 'cotta'
require 'cotta/in_memory_system'
require 'project/cvs_driver'

module BuildMaster

describe CvsDriver do

  before do
    @system = InMemorySystem.new
    @cotta = Cotta.new(@system)
    @working = @cotta.dir('working')
  end
  
  after do
    @system = nil
    @cotta = nil
    @working = nil
  end

  it 'load_CvsInfo' do
    folder = @cotta.dir('tmp')
    folder.mkdirs
    root = ':ext:wolfdancer@cvsserver.com:/cvs/root'
    repository = 'xpe'
    folder.file('ROOT').save(root)
    folder.file('Repository').save(repository)
    cvs = CvsInfo.load(folder)
    cvs.root.should == root
    cvs.repository.should == repository
  end
  
  it 'checkout' do
    @system.output_for_command 'cvs -d root co -d working module', ''
    client = CvsDriver.new(CvsInfo.new('root', 'module'), @working)
    client.checkout
    @system.executed_commands.size.should == 1
  end
  
  it 'update' do
    @system.output_for_command 'cvs -d root update working', ''
    @system.output_for_command 'cvs -d root update -PAd working', ''
    log = ''
    client = CvsDriver.new(CvsInfo.new('root', 'module'), @working)
    client.update
    @system.executed_commands.size.should == 1
    client.update('-PAd')
    @system.executed_commands.size.should == 2
  end
  
  it 'command' do
    @system.output_for_command 'cvs -d root command -option argument working', ''
    log = ''
    client = CvsDriver.new(CvsInfo.new('root', 'module'), @working)
    client.command('command -option argument')
    @system.executed_commands.size.should == 1
  end

end

end