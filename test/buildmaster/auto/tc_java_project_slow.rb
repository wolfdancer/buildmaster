dir = File.dirname(__FILE__)
require dir + '/../test'
require 'spec'

module BuildMaster
  describe JavaProject do
    include TempDirs
    it 'should be able to make' do
      tmp = setup_tmp
      tmp1 = tmp.dir('p1')
      project = JavaProject.new(tmp) do |p|
        p.src = current(__FILE__).dir('javac/src')
        p.output = tmp1
      end
      project.make
      tmp1.dir('prod').should be_exist
      tmp1.file('prod/org/rubyforge/buildmaster/javac/One.class').should be_exist

      tmp2 = tmp.dir('p2')
      project2 = JavaProject.new(tmp) do |p|
        p.src = current(__FILE__).dir('javac/src2')
        p.add_project project
        p.output = tmp2
      end
      project2.make
      tmp2.dir('prod').should be_exist
      tmp2.file('prod/org/rubyforge/buildmaster/javac/Two.class').should be_exist
    end

    it 'should compile test as well' do
      tmp = setup_tmp
      project = JavaProject.new(tmp) do |p|
        p.src = current(__FILE__).dir('javac/src')
        p.output = tmp
        p.test.src = current(__FILE__).dir('javac/src2')
      end
      project.make()
      tmp.dir('prod').should be_exist
      tmp.file('prod/org/rubyforge/buildmaster/javac/One.class').should be_exist
      tmp.dir('test').should be_exist
      tmp.file('test/org/rubyforge/buildmaster/javac/Two.class').should be_exist
    end

    it 'should be able to generate classpath element for ANT build file' do
      current = current(__FILE__)
      output = current.dir('output')
      jar = current.file('lib/lib.jar')
      project = JavaProject.new(current) do |p|
        p.output = output
        p.classpath.add jar
      end
      project.to_ant.should == <<RESULT
    <pathelement location="#{project.prod.output}"/>
    <pathelement location="#{jar}"/>
RESULT
    end

    it 'should copy resources' do
      current = current(__FILE__)
      output = setup_tmp.dir('output')
      project = JavaProject.new(current) do |p|
        p.output = output
        p.src = current.dir('javac/src')
        p.resource = current.dir('javac/src')
      end
      project.make
      output.file('prod/org/rubyforge/buildmaster/javac/One.java').should be_exist
    end

    it 'should package project with classes and source' do
      current = current(__FILE__)
      tmp = setup_tmp
      dist = tmp.dir('dist')
      output = tmp.dir('output')
      project = JavaProject.new(current) do |p|
        p.output = output
        p.src = current.dir('javac/src')
      end
      project.prod.output.mkdirs
      project.test.output.mkdirs
      project.prod.src.mkdirs
      project.package(dist, 'package')
      puts dist.file('package.jar')
      dist.file('package.jar').should be_exist
      dist.file('package-src.zip').should be_exist
    end

  end
end
