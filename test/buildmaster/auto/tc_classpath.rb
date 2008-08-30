$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'buildmaster')
require 'auto'
require 'spec'

module BuildMaster
  describe Classpath do
    it 'sholud be empty when created' do
      path = Classpath.new
      path.should be_empty
      path.include?('test').should == false
      path.to_ant('id').should == ''
    end

    it 'should collect entries by converting to ClasspathEntry' do
      path = Classpath.new
      path.add(Cotta.file('entry'))
      path.should_not be_empty
      path.include?(Cotta.file('entry')).should == true
    end

    it 'should collect classpath entries directly' do
      path = Classpath.new
      path.add(ClasspathEntry.new(Cotta.file('entry')))
      path.include?(Cotta.file('entry')).should == true
    end

    it 'should generate path content only when id is nil' do
      path = Classpath.new
      entry = Cotta.dir('entry')
      path.add(entry)
      path.to_ant.should == <<RESULT
    <pathelement location="#{entry}"/>
RESULT
    end

    it 'should generate path definition part of ANT build file' do
      path = Classpath.new
      entry_dir = Cotta.file('entry')
      path.add(entry_dir)
      path.to_ant('id').should == <<RESULT
  <path id="id">
    <pathelement location="#{entry_dir}"/>
  </path>
RESULT
    end

    it 'should support adding all jars in the directory' do
      path = Classpath.new
      jars_dir = Cotta.file('jars')
      path.add_all(jars_dir)
      path.to_ant('id').should == <<RESULT
  <path id="id">
    <fileset dir="#{jars_dir}">
      <include name="**/*.jar"/>
    </fileset>
  </path>
RESULT
    end

    it 'should support adding another classpath' do
      path = Classpath.new
      entry = Cotta.file('entry')
      path.add(entry)
      path2 = Classpath.new
      entry2 = Cotta.file('entry2')
      path2.add(entry2)
      path2.add(path)
      path2.to_ant('id').should == <<RESULT
  <path id="id">
    <pathelement location="#{entry2}"/>
    <pathelement location="#{entry}"/>
  </path>
RESULT
    end

    it 'should allow string for path when root is set' do
      
    end
  end
end
$:.shift