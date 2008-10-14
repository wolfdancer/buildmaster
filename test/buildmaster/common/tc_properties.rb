require 'spec'
require 'stringio'
require File.dirname(__FILE__) + '/../../../lib/buildmaster/common/properties'

module BuildMaster::Common

  describe Properties do
    it 'parse io into hash' do
      content = <<CONTENT
one : 1
two : 2
three : 3
    
CONTENT
      hash = Properties.parse_io(StringIO.new(content))
      hash.should have_key('one')
      hash['one'].should == '1'
    end

  end

end