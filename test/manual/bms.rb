require File.dirname(__FILE__) + '/../../lib/buildmaster/cotta'
require File.dirname(__FILE__) + '/../../lib/buildmaster/auto'

dir = BuildMaster::Cotta.file(__FILE__).parent.dir('../../tmp/bms')
dir.mkdirs

server = BuildMaster::CI::Server.new
server.serve