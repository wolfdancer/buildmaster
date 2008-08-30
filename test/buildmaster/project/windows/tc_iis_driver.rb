$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'buildmaster')

require 'spec'
require 'windows/iis_driver'

module BuildMaster

describe 'IIS Driver' do

  before do
    @system = mock('system mock')
    cotta = Cotta.new(@system)
    @driver = IisDriver.new(cotta)
  end
  
  it 'should work on real system - requires IIS installed and not running' do
    @driver = IisDriver.new
    @driver.start
    @driver.status
    @driver.stop
  end
  
  it 'should initiate start command' do
    #@system.should_receive(:shell).with 'C:\WINDOWS\system32\iisreset.exe /start'
    @system.should_receive(:shell).with('sc start W3SVC')
    @driver.start
  end
  
end
end