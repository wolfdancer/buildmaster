require File.dirname(__FILE__) + '/../test'

module BuildMaster
  describe Git do
    it 'should take a directory as the working directory' do
      current_dir = Cotta.parent_dir(__FILE__)
      git = Git.new(current_dir)
      git.work_dir.should == current_dir    end
    
    it 'should change directory and run command' do
      current_dir = Cotta.parent_dir(__FILE__)
      Dir.chdir('/') do
        git = Git.new(current_dir)
        git.status.should_not be_empty              end
    end  end
end