#START manifest
require 'buildmaster'

manifest = BuildMaster::JavaManifest.new(File.join(dir, 'core', 'src', 'META-INF', 'MANIFEST.MF'))

version = manifest.increase_build
puts "version number: #{version.number}"
puts "build number: #{version.build}"
#END manifest

#START buildnumber
require 'buildmaster'

buildnumber = BuildMaster::BuildNumberFile.new(File.join(root, 'lib', 'buildmaster', 'buildnumber'))
buildnumber.increase_build
puts "Build Number is: #{buildnumber.number}"
#END buildnumber