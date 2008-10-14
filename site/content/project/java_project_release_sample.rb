$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib')
#START release sample
require 'buildmaster/project'

# Normally you would put release script at the root of the project
cotta = BuildMaster::Cotta.new
root = cotta.file(__FILE__).parent

# BuildMaster can look into svn files to figure out the svn information
svn = BuildMaster::SvnDriver.from_path(root)

# Load Ant Driver uses the ANT build file
ant = BuildMaster::AntDriver.from_file(root.file('build.xml'))

# Java Manifest file that contains version and build information
manifest = BuildMaster::JavaManifest.from_file(root.file('src//META-INF/MANIFEST.MF'))

puts 'updating working directory just in case'
svn.update

puts 'increase build number'
manifest.increase_build

puts 'building application with the updated build number'
ant.target('all')

puts 'check-in build number change'
svn.commit("releasing #{manifest.version.number} build #{manifest.version.build}")

puts 'tagging into <repository-path>/tags/<tag-name>'
svn.tag("project-#{manifest.version}b#{manifest.version.build}")
#END release sample

$:.shift