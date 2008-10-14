dir = File.dirname(__FILE__)

require dir + '../lib/buildmaster/windows'

argument = ARGV[0]
argument = 'status' unless argument

services = [
  BuildMaster::IisDriver.new,
  BuildMaster::SqlServerDriver.new
].each do |service|
  service.send argument
end