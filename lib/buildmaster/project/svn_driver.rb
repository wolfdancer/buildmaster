$:.unshift File.dirname(__FILE__)

require 'stringio'
require 'rexml/document'
require 'svn_status_info'

module BuildMaster

class SvnDriver    
    def SvnDriver::from_path(directory)
        return SvnDriver.new(directory)
    end
    
    attr_reader :work_dir, :repository_url, :user
    
    def initialize(work_dir, repository_root = nil, repository_url = nil)
        @cotta = work_dir.cotta
        @work_dir = work_dir
        @repository_root = repository_root
        @repository_url = repository_url
    end
    
    def repository_root
      load_svn_info unless @repository_root
      return @repository_root
    end
    
    def repository_url
      if (not @repository_url)
        @repository_url = "#{repository_root}/trunk"
      end
      return @repository_url
    end
    
    def user
      load_svn_info unless @repository_root
      return @user
    end
        
    def add(entry)
      @cotta.shell("svn add #{entry.path}")
    end
    
    def remove(entry)
      @cotta.shell("svn remove #{entry.path}")
    end
    
    def status(options = '', &callback)
        command_for_path('status', "#{options}", &callback)
    end
    
    def revert(file)
      @cotta.shell("svn revert #{file}")
    end
    
    def update
        command_for_path('update')
    end
    
    def commit(comment)
        command_for_path('commit', " -m \"#{comment}\"") 
    end
    
    def move(source, target)
      @cotta.shell("svn move #{source} #{target}")
    end
    
    def tag(tag_name)
        @cotta.shell("svn copy #{repository_url} #{repository_root}/tags/#{tag_name} -m \"ruby buildmaster\"")
    end
    
    def checkout(repository_root)
        @repository_root = repository_root
        @cotta.shell("svn checkout #{repository_root}/trunk #{work_dir.path}")
    end
    
    def command(command)
        command_for_path(command)
    end
    
    private
    def load_svn_info
      xml = REXML::Document.new(@cotta.shell("svn info #{work_dir.path} --xml"))
      @repository_root = REXML::XPath.first(xml, '/info/entry/repository/root').text
      @repository_url = REXML::XPath.first(xml, '/info/entry/url').text
      @user = REXML::XPath.first(xml, '/info/entry/commit/author').text
    end
    
    def command_for_path(svn_command, argument='', &callback)
        @cotta.shell("svn #{svn_command} #{@work_dir.path} #{argument}", &callback)
    end
end

end