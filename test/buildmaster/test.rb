current = File.dirname(__FILE__)

require current + '/cotta/physical_system_stub'
require current +'/../../lib/buildmaster/auto'
require 'spec'

module BuildMaster
  module TempDirs
    def setup_tmp
      root = current(__FILE__).parent {|dir| dir.name == 'buildmaster' and dir.dir('bin').exists?}
      output = root.dir('tmp')
      output.delete
      output
    end

    def current(file)
      Cotta.file(file).parent
    end

  end
end