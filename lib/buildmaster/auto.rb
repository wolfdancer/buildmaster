$:.unshift File.join(File.dirname(__FILE__))
require 'cotta'
$:.shift

$:.unshift File.join(File.dirname(__FILE__), 'project')
require 'build_number_file'
require 'java_manifest'
require 'ant_driver'
require 'cvs_driver'
require 'pscp_driver'
require 'svn_driver'
require 'version_number_file'
require 'release'
$:.shift

$:.unshift File.join(File.dirname(__FILE__), 'auto')
require 'classpath'
require 'java'
require 'javac_ant'
require 'junit_ant'
require 'package_ant'
require 'java_project'
require 'mysql_server'
require 'ruby_platform'
$:.shift