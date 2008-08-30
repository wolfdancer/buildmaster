$:.unshift File.join(File.dirname(__FILE__), '..')
require 'test'
require 'spec'

module BuildMaster
  describe JavaProject do
    include TempDirs
    it 'should take path as well as directory' do
      current = current(__FILE__)
      project = JavaProject.new(current) do |p|
        p.output = 'output'
        p.src = 'src'
        p.test.src = 'test'
      end
      project.output.should == current.dir('output')
      project.src.should == current.dir('src')
      project.test.src.should == current.dir('test')
    end

    it 'should allow setting of the classpath' do
      current = current(__FILE__)
      project = JavaProject.new(current) do |p|
        p.uses('lib/one.jar', 'lib/two.jar')
      end
      project.classpath.include?(current.file('lib/one.jar')).should == true
      project.classpath.include?(current.file('lib/two.jar')).should == true
    end

    it 'should allow setting of the test classpath' do
      current = Cotta.parent_dir(__FILE__)
      project = JavaProject.new(current) do |p|
        p.tests_with('lib/one', 'lib/two')
      end
      project.test.classpath.include?(current.dir('lib/one')).should == true
      project.test.classpath.include?(current.dir('lib/two')).should == true
    end

    it 'should let user specify directory to add all jars in' do
      current = Cotta.parent_dir(__FILE__)
      project = JavaProject.new(current) do |p|
        p.uses_files_in('lib/one', 'lib/two')
      end
      project.classpath.include?(ClasspathEntries.new(current.dir('lib/one')))
    end

    it 'should let user specify directory to add all test related jars' do
      current = Cotta.parent_dir(__FILE__)
      project = JavaProject.new(current) do |p|
        p.tests_with_files_in('lib/two', 'lib/three')
      end
      project.test.classpath.include?(ClasspathEntries.new(current.dir('lib/two')))
      project.test.classpath.include?(ClasspathEntries.new(current.dir('lib/three')))
    end

    it 'should construct junit task' do
      current = Cotta.parent_dir(__FILE__)
      project = JavaProject.new(current) do |p|
        p.src = 'src'
        p.output = 'output'
        p.test.src = 'test'
        p.uses('one', 'two')
        p.tests_with('three')
      end
      junit = project.junit(current.dir('report')).for_test('TestClassName')
      junit.test.name.should == 'TestClassName'
      junit.project.should === project
      junit.classpath.to_ant.should == <<RESULT
    <pathelement location="#{project.test.output}"/>
    <pathelement location="#{project.prod.output}"/>
    <pathelement location="#{current.dir('three')}"/>
    <pathelement location="#{current.dir('one')}"/>
    <pathelement location="#{current.dir('two')}"/>
RESULT
    end

  end

end
$:.shift