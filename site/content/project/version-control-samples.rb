#START cvs
require 'buildmaster'
cvs = BuildMaster::CvsDriver.from_path(File.dirname(__FILE__))
# Now your can issue various command
cvs.update
cvs.update('-PAd')
cvs.commit('commit comment')
cvs.tag('tag-name')
# ...
#END cvs

#START svn
require 'buildmaster'
svn = BuildMaster::SvnDriver.from_path(File.dirname(__FILE__))

puts 'committing before release'
svn.commit('committing before release')

tag = "buildmaster-#{SPEC.version}-b#{buildnumber.number}"
puts "tagging with #{tag}"
svn.tag(tag)
#END svn