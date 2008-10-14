require 'spec'

$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib')

context 'example for creating the objects' do

  specify 'creation' do
    # START creation
    require 'buildmaster/cotta'

    # Creat through the factory class instance Cotta
    cotta = BuildMaster::Cotta.new
    file = cotta.file('directory/subdirectory/file.txt')
    dir = cotta.dir('directory/site')

    # Create through the static factory methods on Cotta
    file = BuildMaster::Cotta.file('/tmp/output/file.html')
    dir_of_current_file = BuildMaster::Cotta.parent_of(__FILE__)

    # Create through existing file and directory objects
    dir = file.parent
    file = dir.file('path/to/file.txt')
    # END creation
  end

  specify 'operation' do
    require 'buildmaster/cotta/in_memory_system'
    cotta = BuildMaster::Cotta.new(BuildMaster::InMemorySystem.new)
    root = cotta.file(__FILE__).parent
    root.dir('src').mkdirs
    file = root.file('build/docs/index.txt')
    # START operation
    # load and save
    file.save("* first item\n") # save a content
    file.load                   # => 'first item\n'

    # read and write with optional closure
    file.append {|io| io.puts '* second item'} # appends to the end of file
    file.read {|io| io.gets}                   # => 'first item\n'
    root.dir('src').copy_to(root.dir('build/docs/source'))
    root.dir('build/docs').archive.zip         # => resuling tar zip file build/docs.tar.zip
    # END operation
    file.read {|io| io.gets}.should == "* first item\n"
  end

  specify 'test' do
    # START test
    require 'buildmaster/cotta/in_memory_system'
    require 'buildmaster/project'

    cotta = BuildMaster::Cotta.new(BuildMaster::InMemorySystem.new)
    file = cotta.file('/root/file.txt')
    file.write {|io| io.puts '1.2.1'}
    BuildMaster::VersionNumberFile.new(file).version_number.should == '1.2.1'
    # END test
    end
end

$:.shift