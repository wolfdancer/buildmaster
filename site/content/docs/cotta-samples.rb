#START create
# Cotta uses physical file system by default
cotta = BuildMaster::Cotta.new
# or you can pass in InMemorySystem for testing
cotta = BuildMaster::Cotta.new(BuildMaster::InMemorySystem.new)
# with cotta, you can instantiate file or directory using path string
file = cotta.file(__FILE__)
directory = cotta.dir('dir/subdir')
# each file or directory object can instantiate other file and directory
parent_dir = file.parent
child_file = directory.file('index.html')
#END create

#START ops
# file has path attribute that returns pathname, which contains useful methods.
pathname = file.path
file.save('content')
if (not file2.exists?)
  file.copy_to(file2)
end
file2.load
#END ops

#START io
file.read {|handler| REXML::Document.new handler}
file.write {|handler| document.write(handler, 0, false, true)}
#END io