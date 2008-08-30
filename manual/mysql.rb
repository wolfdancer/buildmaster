$:.unshift File.join(File.dirname(__FILE__), '..', 'lib', 'buildmaster')

require 'auto'

mysql = BuildMaster::MySqlServer.new(BuildMaster::Cotta.dir('D:\Tools\mysql-5.0.51a-win32'))
if (ARGV.empty?)
  mysql.start
elsif ARGV[0] == 'stop'
  mysql.stop
else
  mysql.run ARGV
end
