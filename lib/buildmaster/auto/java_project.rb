module BuildMaster
  # Java project that knows how to compile the production and test source
  class JavaProject
    attr_accessor :output, :name, :target_version
    attr_reader :root, :prod, :test, :output
    
    def initialize(root)
      @root = root
      @prod = ProjectInfo.new(self)
      @prod.classpath = Classpath.new(root)
      @test = ProjectInfo.new(self)
      @test.classpath = Classpath.new(root)
      prod.src=root.dir('src')
      test.src=root.dir('test')
      self.output=root.dir('output')
      if block_given?
        yield self
      end
    end

    def src=(dir)
      prod.src = dir
    end

    def src
      prod.src
    end

    def resource=(dir)
      prod.resource = dir
    end

    def resource
      prod.resource
    end

    def output=(dir)
      @output = dir(dir)
      @prod.output=@output.dir('prod')
      @test.output=@output.dir('test')
    end

    # Specifies that the current project uses the entry
    # The entry can be one of the three things:
    # It can be another JavaProject, in which case it will be added as a classpath element.
    # In this case, the project output and its classpath will be part of the current project
    # classpath.  It can also be a CottaDirectory or CottaFile, in which case it will be added
    # to the classpath.  It can also be a path string, in which case it will be converted to
    # CottaFile or CottaDirectory based on whether or not the extname is empty
    def uses(*entries)
      add_entry(@prod, entries)
    end

    def uses_files_in(*dirs)
      dirs.each {|dir| @prod.classpath.add_all(dir(dir))}
    end

    def tests_with(*entries)
      add_entry(@test, entries)
    end

    def tests_with_files_in(*dirs)
      dirs.each {|dir| @test.classpath.add_all(dir(dir))}
    end

    def classpath
      @prod.classpath
    end

    def add_project(project)
      @prod.classpath.add project
    end

    def javac(buildfile = nil)
      javac = JavacAnt.new(prod.output, buildfile)
      javac.target_version = target_version
      javac.src = prod.src
      javac.classpath.add prod.classpath unless prod.classpath.empty?
      javac.resource = prod.resource if prod.resource
      result = nil
      if (test.src.nil?)
        result = [javac]
      else
        javac_test = JavacAnt.new(test.output, buildfile)
        javac_test.target_version = target_version
        javac_test.src = test.src
        javac_test.resource = test.resource if test.resource
        javac_test.classpath.add prod.output
        javac_test.classpath.add prod.classpath unless prod.classpath.empty?
        javac_test.classpath.add test.classpath unless test.classpath.empty?
        result = [javac, javac_test]
      end
      result
    end

    def junit(report_dir)
      junit = JUnitAnt.new(report_dir, self)
      junit.classpath.add test.output
      junit.classpath.add prod.output
      junit.classpath.add test.classpath
      junit.classpath.add prod.classpath
      junit
    end

    def javadoc(report_dir)
      javadoc = JavaDocAnt.new(report_dir)
      javadoc.src = prod.src
      javadoc
    end

    def make(buildfile = nil)
      javac(buildfile).each {|javac|  javac.compile}
    end

    def package(dir, name)
      ant = PackageAnt.new(dir, name)
      ant.add(prod.output, prod.src)
      yield ant if block_given?
      ant.run
    end

    def jar(file)
      
    end

    def clean
      output.delete
    end

    def rebuild
      clean
      make
    end

    # create XML classpath element for ANT build file
    def to_ant
      io = StringIO.new
      io << ClasspathEntry.new(prod.output).to_ant
      io << classpath.to_ant
      io.string
    end

    def dir(path)
      if (path.class == String)
        @root.dir(path)
      else
        path
      end
    end

    def file(path)
      if (path.class == String)
        @root.file(path)
      else
        path
      end
    end

    private
    def guess_entry(entry)
      path = Pathname.new(entry)
      if (path.extname.empty?)
        dir(entry)
      else
        file(entry)
      end
    end

    def add_entry(target, entries)
      entries.each do |entry|
        if (entry.class == String)
          entry = guess_entry(entry)
        end
        target.classpath.add(entry)
      end
    end
  end

  class ProjectInfo
    attr_accessor :src, :classpath, :output, :resource

    def initialize(project)
      @project = project
    end

    def src=(source)
      @src = @project.dir(source)
    end

    def resource=(resource)
      @resource = @project.dir(resource)
    end
  end
end