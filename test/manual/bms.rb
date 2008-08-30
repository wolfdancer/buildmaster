$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'buildmaster')

require 'cotta'
require 'ci'

dir = BuildMaster::Cotta.file(__FILE__).parent.dir('../../tmp/bms')
dir.mkdirs

server = BuildMaster::CI::Server.new
server.serve