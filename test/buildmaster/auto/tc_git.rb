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
    end
    
    it 'should issue proper commands' do
      system = InMemorySystem.new
      cotta = Cotta.new(system)
      work = cotta.dir('/tmp/work')
      system.output_for_command('git pull', 'pull output')
      system.output_for_command('git add .', 'add output')
      system.output_for_command("git add #{work.file('file.txt')}", 'add output')
      system.output_for_command("git commit -m \"comment\"", 'commit output')
      git = Git.new(work)
      git.pull
      git.add
      git.add(work.file('file.txt'))
      git.commit('comment')    end  end
end