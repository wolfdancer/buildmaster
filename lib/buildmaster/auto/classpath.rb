module BuildMaster
  class ClasspathEntry
    attr_reader :path
    
    def initialize(path)
      @path = path
    end

    def to_ant
      "    <pathelement location=\"#{@path}\"/>\n"
    end

    def ==(other)
      other.class == ClasspathEntry and other.path == path
    end
  end

  class ClasspathEntries
    def initialize(dir)
      @dir = dir
    end

    def to_ant
      return <<RESULT
    <fileset dir="#{@dir}">
      <include name="**/*.jar"/>
    </fileset>
RESULT
    end
  end

  class Classpath
    
    def initialize(root = nil)
      @entries = Array.new
      @root = root
    end

    def include?(entry)
      @entries.include?(convert(entry))
    end

    def insert(entry)
      @entries.unshift(convert(entry))
    end

    def add(entry)
      @entries.push(convert(entry))
    end

    def add_all(dir)
      @entries.push(ClasspathEntries.new(dir))
    end

    def empty?
      @entries.empty?
    end

    def to_ant(id=nil)
      return '' if empty?
      result = entries_to_ant
      if (not id.nil?)
        result = <<RESULT
  <path id="#{id}">
#{result}  </path>
RESULT
      end
      result
    end

    private
    def entries_to_ant
      io = StringIO.new
      @entries.each {|entry| io << "#{entry.to_ant}"}
      io.string
    end

    def convert(entry)
      if (entry.respond_to? :to_ant)
        entry
      else
        ClasspathEntry.new(entry)
      end
    end
  end
end