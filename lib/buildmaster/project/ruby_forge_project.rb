$:.unshift File.dirname(__FILE__)
require 'svn_driver'

module BuildMaster
class RubyForgeProject
  attr_reader :source_repository, :svn, :name, :group_id

  def initialize(name, group_id)
    @name = name
    @group_id = group_id
  end
  
  def source_repository
    "http://rubyforge.org/viewvc/trunk/?root=#{name}"
  end
  
  def release_download_url
    "http://rubyforge.org/frs/?group_id=#{group_id}"
  end
  
  def svn_trunk_url(user)
    "svn+ssh://#{user}@rubyforge.org/var/svn/#{name}/trunk"
  end
    
end
end