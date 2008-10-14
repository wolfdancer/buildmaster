require File.dirname(__FILE__) + '/../../../lib/buildmaster/auto'
require 'spec'

module BuildMaster
  describe RubyPlatform do
    it 'should detect current OS' do
      RubyPlatform.os.should_not be_nil
    end
  end
end