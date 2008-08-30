#START rake
require 'rakefile'
load 'rake'
#END rake

#START ant
  require 'buildmaster'

  # Load the AntDriver by passing in the path to the build.xml file
  build_file = File.join(File.dirname(__FILE__), "build.xml")
  ant = AntDriver.from_file(build_file)

  # You can treat each target as a method and invoke them directly
  ant.build
#END ant