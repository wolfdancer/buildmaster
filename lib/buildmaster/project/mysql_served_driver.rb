require '../cotta'
require '../cotta/in_memory_system'

module BuildMaster
class MySqlServerDriver
  def initialize(mysqld)
    @mysqld = mysqld
    @cotta = mysqld.cotta
  end

  def start
    @cotta.shell("#{@mysqld.path} --console")
  end
end
end