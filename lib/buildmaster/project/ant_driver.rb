module BuildMaster

# ANT launcher class to run targets on an ANT build file.
class AntDriver
  
  # Create the instance given a CottaFile instance
  def AntDriver.from_file(ant_file)
    return AntDriver.new(ant_file)
  end
  
  # Create the instance given a CottaFile
  def initialize(ant_file = nil)
    @cotta = Cotta.new(ant_file.system)
    @ant_file = ant_file
    ant_path = @cotta.environment!('ANT_HOME')
    @ant_home = @cotta.dir(ant_path)
    raise 'ANT_HOME need to point to ANT home directory' unless @ant_home.exists?
    if RUBY_PLATFORM =~ /[^r]win/ # Windows and not darwin
      @class_path_delimiter = ';'
      @path_seperator='\\'
    else
      @class_path_delimiter = ':'
      @path_seperator='/'
    end
    @java_command = get_java_command()
    @ant_options = @cotta.environment('ANT_OPTS').split(' ')
    @ant_arguments = @cotta.environment('ANT_ARGS').split(' ')
    @ant_options.putsh(ENV['JIKESPATH']) if ENV['JIKESPATH']
    @classpath=ENV['CLASSPATH']
  end
  
  def get_java_command
    java_home = @cotta.environment('JAVA_HOME')
    if java_home
      command = [java_home, 'bin', 'java'].join(@path_seperator)
    else
      command = @cotta.environment('JAVA_CMD', 'java')
    end
    return command
  end
  
  def project_help
    launch('-projecthelp')    
  end
  
  def target(name)
    launch(name)
  end

  def launch(arguments, &block)
    local_path = "#{@ant_home.path}/lib/ant-launcher.jar"
    if (@classpath and @classpath.length() > 0)
      local_path = "#{local_path}#{@class_path_delimiter}#{@classpath}"
    end
    all_arguments = Array.new()
    all_arguments.push(@ant_options)
    all_arguments.push('-classpath', "\"#{local_path}\"")
    all_arguments.push("-Dant.home=#{@ant_home.path}")
    all_arguments.push('org.apache.tools.ant.launch.Launcher', @ant_arguments);
    all_arguments.push('-f', @ant_file.path) if @ant_file
    all_arguments.push(arguments)
    command_line = "#{@java_command} #{all_arguments.join(' ')}"
    @cotta.shell(command_line, &block)
  end
  
  def respond_to?(*args)
    super(args)
  end
  
  def method_missing(method, *args)
    target(method)
  end
  
  private :get_java_command

end

class RubyAnt
  def initialize(ant_file = nil, &command_runner)
    @ant_file = ant_file
    @ant_home = check_directory(get_environment('ANT_HOME'))
    @java_command = get_environment_or_default('JAVA_CMD', 'java')
#ISSUE: what java wants to split up classpath varies from platform to platform 
#and ruby, following perl, is not too hot at hinting which box it is on.
#here I assume ":" except on win32, dos, and netware. Add extra tests here as needed.
    #This is the only way I know how to check if on windows
    if File.directory?('C:')
      @class_path_delimiter = ';'
    else
      @class_path_delimiter = ':'
    end
    @ant_options = get_environment_or_default('ANT_OPTS').split(' ')
    @ant_arguments = get_environment_or_default('ANT_ARGS').split(' ')
    @ant_options.putsh(ENV['JIKESPATH']) if ENV['JIKESPATH']
    @classpath=ENV['CLASSPATH']
    @command_runner = command_runner
  end
  
  def launch(arguments)
    local_path = "#{@ant_home}/lib/ant-launcher.jar"
    if (@classpath and @classpath.length() > 0)
      local_path = "#{local_path}#{@class_path_delimiter}#{@classpath}"
    end
    all_arguments = Array.new()
    all_arguments.push(@ant_options)
    all_arguments.push('-classpath', local_path)
    all_arguments.push("-Dant.home=#{@ant_home}")
    all_arguments.push('org.apache.tools.ant.launch.Launcher', @ant_arguments);
    all_arguments.push('-f', @ant_file) if @ant_file
    all_arguments.push(arguments)
    command_line = "#{@java_command} #{all_arguments.join(' ')}"
    run_command(command_line)
  end
  
  private
  def run(command)
    if (!system(command))
      raise "error running command: #{command}"
    end
  end
  
  def run_command(full_command)
    if (@command_runner)
      @command_runner.call(full_command)
    else
      run(full_command)
    end
  end
  
  private
  def check_directory(path)
    raise "#{path} is not a directory" unless File.directory? path    
    return path
  end
  
  def get_environment(name)
    value = ENV[name]
    raise "#{name} is not set" unless value
    return value
  end
  
  def get_environment_or_default(name, default_value='')
    value = ENV[name]
    value = default_value if not value
    return value
  end
end

end