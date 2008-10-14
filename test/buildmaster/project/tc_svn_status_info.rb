require 'spec'
require File.dirname(__FILE__) + '/../test'

module BuildMaster

  describe SvnStatusInfo do
    it 'parse local changes' do
      content = <<CONTENT
<?xml version="1.0"?>
<status>
<target
   path=".">
<entry
   path="pathone">
<wc-status
   props="none"
   item="unversioned">
</wc-status>
</entry>
<entry
   path="pathtwo">
<wc-status
   props="none"
   item="unversioned">
</wc-status>
</entry>
</target>
</status>
CONTENT
      info = SvnStatusInfo.parse_xml(content)
      info.should have(2).unversioned
    end
  end

end