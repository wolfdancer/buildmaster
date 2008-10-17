require File.dirname(__FILE__) + '/../test'

module BuildMaster
  describe Git do
    it 'should take a directory as working directory' do
      current_dir = Cotta.parent_dir(__FILE__)
      git = Git.new(current_dir)
      git.work_dir.should == current_dir    end
    
    it 'should change directory and run command' do
      current_dir = Cotta.parent_dir(__FILE__)
      Dir.chdir('/') do
        git = Git.new(current_dir)
        git.status.should_not be_empty              end
    end
    
    it 'should issue proper commands' do
      system = InMemorySystem.new
      cotta = Cotta.new(system)
      work = cotta.dir('/tmp/work')
      git = Git.new(work)
      git.pull
      git.add
      git.add(work.file('file.txt'))
      git.commit('"comment"')
      system.executed_commands.should == []    end  end
end