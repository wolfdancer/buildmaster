module BuildMaster
  # A utiliy class that helps figuring out the right file name
  # by OS based on RUBY_PLATFORM
  class RubyPlatform
    # Returns the current OS, the values can be ':windows', ':unix'
    # Note: linux, unix and mac are treated the same at this level, and cygwin is
    # considered windows because the executables are still in windows naming convention
    def self.os
      value = nil
      if RUBY_PLATFORM =~ /[^r]win/
        value = :windows
      else
        value = :unix
      end
      value
    end

    # Returns the execution file name, for windows this will be
    # with 'exe' extension or 'bat', for linux this will be with no extension
    # or with 'sh' extension.  If file is not found, this will return null
    def self.locate_execution_file(dir, path)
      file = dir.file(path)
      if (not file.exists?)
        os_value = os
        if (:windows == os_value)
          file = dir.file("#{path}.exe")
          if (not file.exists?)
            file = dir.file("#{path}.bat")
          end
          if (not file.exists?)
            file = nil
          end
        else
          file = dir.file("#{path}.sh")
          if (not file.exists?)
            file = nil
          end
        end
      end
      file
    end
    
    # Same as locate_execution_file except this will throw an error if 
    # file is not found
    def self.locate_execution_file!(dir, path)
      file = locate_execution_file(dir, path)
      raise "No suitable execution file found under #{dir} using #{path}" unless file
      file
    end
  end
end