module BuildMaster
  class Git
    attr_reader :work_dir
    def initialize(work_dir)
      @work_dir = work_dir
    end
    
    def status
      command('status')
    end
    
    private
    def command(command)
      Dir.chdir(@work_dir.path) do
        @work_dir.cotta.shell("git #{command}")
      end
    end
  end
end