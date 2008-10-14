require 'spec'
require File.dirname(__FILE__) + '/../test'

module BuildMaster

describe Release do
  it 'run tasks in order' do
    mock = mock('tasks')
    mock.should_receive(:one).once.ordered
    mock.should_receive(:two).once.ordered
    release = Release.new
    release.task('one') {mock.one}
    release.task('two') {mock.two}
    release.execute
  end
  
  it 'run task from specified step in order' do
    mock = mock('tasks')
    mock.should_receive(:two).once.ordered
    mock.should_receive(:three).once.ordered
    release = Release.new
    release.task('one') {mock.one}
    release.task('two') {mock.two}
    release.task('three') {mock.three}
    release.execute('two')
  end
  
  it 'run tasks between two' do
    mock = mock('tasks')
    mock.should_receive(:two).once.ordered
    mock.should_receive(:three).once.ordered
    release = Release.new
    release.task('one') {mock.one}
    release.task('two') {mock.two}
    release.task('three') {mock.three}
    release.task('four') {mock.four}
    release.execute('two', 'three')
  end
  
  it 'don\'t allow duplicate tasks' do
    release = Release.new
    release.task('one') {}
    Proc.new {release.task('one')}.should raise_error(RuntimeError)
  end
  
  it 'raise error for task not found' do
    release = Release.new
    release.task('two') {}
    Proc.new {release.execute('one')}.should raise_error(RuntimeError)
  end
  
  it 'raise error for empty task' do
    release = Release.new
    Proc.new {release.execute}.should raise_error(RuntimeError)
  end
  
end

end