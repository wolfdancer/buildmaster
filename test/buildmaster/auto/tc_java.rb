$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'buildmaster')
require 'auto'
require 'spec'

module BuildMaster
  describe Java do
    it 'should get version' do
      java = Java.new
      java.version.should_not be_nil
    end
  end
end