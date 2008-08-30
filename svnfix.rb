$:.unshift File.join(File.dirname(__FILE__), 'lib', 'buildmaster')

require 'project/svn_helper'

BuildMaster::SvnHelper.from_directory('.').fix
