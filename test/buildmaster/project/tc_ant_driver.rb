$:.unshift File.join(File.dirname(__FILE__), "..", "..", '..', "lib", "buildmaster")

require 'spec'
require 'project'
require 'cotta'

module BuildMaster

describe AntDriver do
  before do
    cotta = Cotta.new()
    build_file = cotta.file(__FILE__).parent.file('build.xml')
    @ant = AntDriver.from_file(build_file)
  end

  it 'run' do
    @ant.project_help
  end
  
  it 'pass' do
    @ant.target('passing')
  end
  
  it 'dynamic_method' do
    @ant.passing
  end
  
  it 'fail' do
    lambda {@ant.target('failing')}.should raise_error(CommandError)
  end
end

end