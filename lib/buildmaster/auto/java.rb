module BuildMaster
  class Java
    def initialize(java_home=nil)
      @home = java_home
      if @home.nil?
        @cotta = Cotta.new
      else
        @cotta = @home.cotta
      end
    end

    def version
      @cotta.shell("#{java_exe} -version")
    end

    private
    def java_exe
      exe = 'java'
      exe = @home.file('bin/java') if @home
      exe
    end
  end
end