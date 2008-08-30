#START site spec
class MySiteSpec < BuildMaster::SiteSpec
#  ...

  def index_file?(content_path)
    return content_path =~ /index/
  end
  
#  ...
end
#END site spec

#START test
require 'buildmaster'
BuildMaster::SiteTester.test('http://buildmaster.rubyforge.org')
#END test
