module BuildMaster

class Release
  def initialize
    @tasks = []
  end

  def task(name, &callback)
    raise "#{name} task already exists in #{@tasks}" if task_by_name(name)
    @tasks.push ReleaseTask.new(name, &callback)
  end
  
  def command(arguments)
    if arguments.include? '-p'
      print
    else
      start = arguments.shift
      finish = arguments.shift
      execute(start, finish)
    end
  end
  
  def print
    @tasks.each {|task| puts "#{task.name} "}
  end
  
  def execute(start = nil, finish = nil)
    start_index = select_with_default(start, 0)
    finish_index = select_with_default(finish, @tasks.size - 1)
    raise "No tasks from #{start} to #{finish} in #{@tasks}" if (start_index > finish_index)
    start_index.upto(finish_index) do |i| 
      puts "[#{i}] #{@tasks[i].name}:"
      @tasks[i].execute
    end
  end
  
  private
  def select_with_default(name, default_if_nil)
    return default_if_nil unless name
    match = task_by_name(name)
    raise "Task not found: #{name}" unless match
    @tasks.index(match)
  end
  
  def task_by_name(name)
    @tasks.find {|task| task.name == name}
  end
end

class ReleaseTask
  attr_reader :name

  def initialize(name, &callback)
    @name = name
    @callback = callback
  end
  
  def execute
    @callback.call
  end
  
  def to_s
    "[#{name}]"
  end
end

end