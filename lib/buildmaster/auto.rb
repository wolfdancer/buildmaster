dir = File.dirname(__FILE__)
require dir + '/cotta'

project = dir + '/project'
require project + '/build_number_file'
require project + '/java_manifest'
require project + '/ant_driver'
require project + '/cvs_driver'
require project + '/pscp_driver'
require project + '/svn_admin_driver'
require project + '/svn_driver'
require project + '/svn_status_info'
require project + '/server_manager'
require project + '/version_number_file'
require project + '/release'
require project + '/ci'

auto = dir + '/auto'
require auto + '/classpath'
require auto + '/git'
require auto + '/java'
require auto + '/javac_ant'
require auto + '/junit_ant'
require auto + '/java_doc_ant'
require auto + '/package_ant'
require auto + '/java_project'
require auto + '/mysql_server'
require auto + '/ruby_platform'
