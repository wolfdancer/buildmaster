$:.unshift File.join(File.dirname(__FILE__), '..')
require 'cotta/cotta'
require 'cotta/in_memory_system'

module BuildMaster
class IisDriver
  def initialize(cotta=Cotta.new)
    @cotta = cotta
#    @executable = 'C:\\WINDOWS\\system32\\iisreset.exe'
#    if (not cotta.file(@executable).exists?)
#      raise "#{@executable} not found"
#    end
  end

  def status
    execute('query')
  end

  def start
    execute('start')
  end

  def stop
    execute('stop')
  end

  private
  def execute(command)
    #@cotta.shell("#{@executable} /#{command}")
    @cotta.shell("sc #{command} W3SVC")
  end
end
end
