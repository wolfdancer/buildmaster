$:.unshift File.join(File.dirname(__FILE__), '..')
require 'test'
require 'spec'

module BuildMaster
  describe JavacAnt do
    include TempDirs
    it 'should compile with library' do
      output = setup_tmp
      output1 = output.dir('classes1')
      output2 = output.dir('classes2')

      # compile without any library
      javac = JavacAnt.new(output1)
      javac.src = current(__FILE__).dir('javac/src')
      javac.compile()
      output1.file('org/rubyforge/buildmaster/javac/One.class').should be_exist
      output1.file('org/rubyforge/buildmaster/javac/One.java').should_not be_exist
      output1.file('resource.txt').should be_exist

      # compile with library
      javac = JavacAnt.new(output2)
      javac.src = current(__FILE__).dir('javac/src2')
      javac.classpath.add output1
      javac.compile()
      output2.file('org/rubyforge/buildmaster/javac/Two.class').should be_exist
    end

    it 'should copy all resources that are not in src' do
      output = setup_tmp
      javac = JavacAnt.new(output)
      javac.src = current(__FILE__).dir('javac/src')
      javac.resource = current(__FILE__).dir('javac/src2')
      javac.compile
      output.file('org/rubyforge/buildmaster/javac/One.class').should be_exist
      output.file('org/rubyforge/buildmaster/javac/Two.java').should be_exist
    end
  end
end
$:.shift