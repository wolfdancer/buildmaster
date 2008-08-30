$:.unshift File.join(File.dirname(__FILE__), "..", "..", '..', "lib", 'buildmaster')

require 'spec'
require 'project/svn_admin_driver'
require 'cotta'
require 'cotta/in_memory_system'

module BuildMaster

describe SvnDriver do
  before do
    file = File.expand_path(__FILE__)
    test_dir = Cotta.new.file(file).parent.parent.parent.dir('tmp/svn_test')
    test_dir.delete if (test_dir.exists?)
    test_dir.mkdirs
    @repository = test_dir.dir('repository')
    @url = "file:///#{@repository.path}"
    @svn_admin = SvnAdminDriver.new(@repository.path)
    @svn_admin.create
    @work_dir_root = test_dir.dir('workdir')
    @svn = SvnDriver.new @work_dir_root
  end
  
  it 'check out, add, commit, update' do
    second = @work_dir_root.parent.dir('second')
    second_svn = SvnDriver.new(second)
    @svn.checkout(@url)
    second_svn.checkout(@url)
    @work_dir_root.file('test.txt').save('my testing content')
    @svn.add(@work_dir_root.file('test.txt'))
    @svn.commit('testing the checkin')
    second_svn.update
    second.file('test.txt').load.should == 'my testing content'
    svn2 = SvnDriver.from_path(second)
    svn2.work_dir.should == second_svn.work_dir
    svn2.repository_url.should == second_svn.repository_url
    svn2.user.should_not be(nil)
    svn2.repository_root.should == second_svn.repository_root
  end

=begin  
  def expect_info
    @system.should_receive(:shell).with("svn info #{@work_dir_root.path}").and_return(<<CONTENT
Path: .
URL: svn+ssh://wolfdancer@rubyforge.org/var/svn/buildmaster/trunk
Repository Root: svn+ssh://wolfdancer@rubyforge.org/var/svn/buildmaster
Repository UUID: ab7ff8c2-9713-0410-a269-a4b56b3120d2
Revision: 153
Node Kind: directory
Schedule: normal
Last Changed Author: wolfdancer
Last Changed Rev: 153
Last Changed Date: 2006-10-15 21:27:51 -0700 (Sun, 15 Oct 2006)
CONTENT
)
  end
  
  it 'load svn info from the info command' do
    expect_info
    @svn.work_dir.should == @work_dir_root
    @svn.repository_root.should == 'svn+ssh://wolfdancer@rubyforge.org/var/svn/buildmaster'
  end
  
  it 'svn status command' do
    log = ''
    @system.should_receive(:shell).with "svn status #{@work_dir_root.path}"
    @svn.status
  end
  
  it 'svn update command' do
      log = ''
      @system.should_receive(:shell).with "svn update #{@work_dir_root.path}"
      @svn.update
  end
  
  it 'svn commit command' do
    @system.should_receive(:shell).with "svn commit #{@work_dir_root.path} -m \"message\""
    @svn.commit('message')
  end
  
  it 'svn check out command' do
    expect_info
    repository_root = @svn.repository_root
    @system.should_receive(:shell).with "svn checkout #{repository_root}/trunk output"
    @svn.checkout('output')
  end
  
  it 'svn command' do
    @system.should_receive(:shell).with "svn info #{@work_dir_root.path}"
    @svn.command('info')
  end
  
  it 'svn tag' do
    expect_info
    tag = 'build_0.0.5_b3'
    @system.should_receive(:shell).with("svn copy #{@svn.repository_root}/trunk #{@svn.repository_root}/tags/#{tag} -m \"ruby buildmaster\"")
    @svn.tag(tag)
  end
  
  it 'physical svn works' do
    cotta = Cotta.new
    svn = SvnDriver.new(cotta.file(__FILE__).parent)
    svn.repository_root.should == 'svn+ssh://wolfdancer@rubyforge.org/var/svn/buildmaster'
  end
=end
    
end

end