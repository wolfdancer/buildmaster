module BuildMaster

=begin
A helper class that use svn driver to help svn command line.  It analyze the local
changeset, finds the missing file list and unversioned file list, then does three things:

* For each missing file list, looks through the unversioned file to see if there is a name
match, if so, perform the svn move operation, if not, prompt the user.
* For what is left of missing file list, prompt for removing the file.
* For what is left of unversioned file list, prompt for adding the file.
=end
class SvnHelper
  def SvnHelper::from_file(file_under_root)
    SvnHelper.new(Cotta.new.file(file_under_root).parent)
  end
  
  def SvnHelper::from_directory(working_directory)
    SvnHelper.new(Cotta.new.dir(working_directory))
  end

  def initialize(work_dir)
    @work_dir = work_dir
    @svn = SvnDriver.new @work_dir
  end
  
  def fix
    status_xml = get_status_xml
    status_info = SvnStatusInfo.parse_xml(status_xml)
    @svn.status
    unversioned = status_info.unversioned
    missing = status_info.missing
    missing.each do |entry|
      target = find_candidate(unversioned, entry)
      target = prompt_for_candidate(entry, unversioned) unless target || unversioned.empty?
      if (target)
        tmp = "#{target.path}.buildmaster"
        @svn.revert(entry.path)
        @work_dir.cotta.entry(target.path).move_to_path(tmp)
        # TODO check if the source has was added, if so remove it
        # if modified, we need to save the file somewhere else, revert this one, move it, then move the files back
        @svn.move(entry.path, target.path)
        target_entry = @work_dir.cotta.entry(target.path)
        target_entry.delete
        @work_dir.cotta.entry(tmp).move_to(target_entry)
        unversioned.delete_if {|item| item.path == target.path}
        missing.delete_if {|item| item.path == entry.path}
      end
    end
    unversioned.each {|path| prompt_and_add(path)}
    missing.each {|path| prompt_and_remove(path)}
  end
  
  private
  def get_status_xml
    xml = ''
    @svn.status('--xml') do |io|
      while (line = io.gets)
        xml << line
      end
    end
    return xml
  end
  
  def find_candidate(unversioned, entry)
    matching = unversioned.select {|candidate| candidate.path.basename == entry.path.basename}
    if (matching.size == 1)
      return matching[0]
    end
    return nil
  end
  
  def prompt_and_add(entry)
    answer = enter("add #{entry.path} to svn? (enter for yes, 'n' for no)") {|line| line.nil? || line == 'n'}
    @svn.add(Cotta.new().entry(entry.path)) unless answer
  end
  
  def prompt_and_remove(entry)
    answer = enter("remove #{entry.path} from svn? (enter for yes, 'n' for no") {|line| line.nil? || line == 'n'}
    @svn.revert(entry.path)
    if File.exists?(entry.path)
      @svn.remove(Cotta.new().entry(entry.path)) unless answer
    end
  end
  
  def prompt_for_candidate(entry, candidates)
    puts "#{entry.path} is missing, pick one from the following or press enter to skip"
    candidates.each {|value| puts "> #{value.path}"}
    entry = enter("if you moved this file, enter the location it is moved to: ") {|line| line.nil? || candidates.include?(Pathname.new(line))}
    return entry
  end
  
  def enter(prompt)
    puts prompt
    print '> '
    line = gets.strip
    line = nil if line.empty?
    until (yield line)
      puts "invalid choice '#{line}', enter again."
      print '> '
      line = gets.strip
      line = nil if line.empty?
    end
    return line
  end

end
end