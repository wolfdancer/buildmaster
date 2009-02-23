require 'fileutils'

module BuildMaster
  class NullLogger
    def << message
     puts "IGNORED: #{message}"
    end
  end

  class Site
    def Site::setup(spec, templates_dir = spec.cotta.dir(__FILE__).parent.dir('templates'))
      command_line = spec.cotta.command_interface
      command_line.puts 'setting up site'
      candidates = collect_candidates(templates_dir).collect {|item| item.name}
      selection = command_line.prompt_for_choice('Select the template that you want to use', candidates)
      selected_dir = templates_dir.dir(selection)
      selected_dir.file('template.html').copy_to(spec.template_file)
      selected_dir.dir('content').copy_to(spec.content_dir)
    end
    
    def Site::collect_candidates(dir)
      dir.list.select do |item|
        item.respond_to?(:file) && item.file('template.html').exists?
      end
    end
  
    def initialize(spec)
      @spec = spec
      @spec.validate_inputs
      @template = @spec.load_template
    end
    
    public
    def output_dir
      @spec.output_dir
    end
    
    def execute(arguments)
      action = 'build'
      if arguments.size > 0
        action = arguments[0]
      end
      send action
    end
    
    def build
      @count = 0
      build_directory(@spec.output_dir, @spec.content_dir, @template)
      puts "Generated file count: #{@count}"
    end
    
    def server(*args)
      @server = SiteServer.new(@spec, *args)
      ['INT', 'TERM'].each { |signal|
           trap(signal){ @server.stop} 
      }  
      @server.start
    end
    
    def test(port_number=2000)
      launch_server(port_number) {|port_number| SiteTester.test("http://localhost:#{port_number}/index.html")}
    end
    
    def test_offline(port_number=2000)
      launch_server(port_number) {|port_number| SiteTester.test_offline("http://localhost:#{port_number}/index.html")}
    end
    
    private
    
    def launch_server(port_number)
require 'buildmaster/site_tester'
      Thread.new() {server(port_number, NullLogger.new, 0, NullLogger.new)}
      begin
        sleep(2)
        yield port_number
      ensure
        @server.stop
      end 
    end
    
    def build_directory(out_dir, content_dir, template)
      out_dir.mkdirs
      content_dir.list.each do |item|
        if (item.name == '.svn' || item.name == 'CVS' || item.name == '_svn')
        elsif (item.respond_to? 'list')
          build_directory(out_dir.dir(item.name), item, template)
        elsif (item.respond_to? 'read')
          @current_file_name = item
          if(process_file(item, out_dir, content_dir, item))
            @count = @count + 1
          end
        end
      end
    end
    
    def process_file(content_file, out_dir, content_dir, item)
      processor = FileProcessor.new(@template, content_file, @spec)
      processed = nil
      if (processor.out_of_date?)
        print ">> #{content_file.path.to_s}\n"
        processor.write_to_target
        processed = true
      end
      processed
    end
    
  end
  
end
