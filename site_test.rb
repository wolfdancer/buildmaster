require 'lib/buildmaster/site_tester'

BuildMaster::SiteTester.test_offline('http://localhost:2000/docs/tag-references.html')
#BuildMaster::SiteTester.test('http://opensource.thoughtworks.com')
