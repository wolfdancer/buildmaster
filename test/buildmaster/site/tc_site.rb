$:.unshift File.join(File.dirname(__FILE__), "..", "..", '..', "lib", 'buildmaster')

require 'spec'
require 'site/site'
require 'cotta'
require 'cotta/command_interface'
require 'cotta/in_memory_system'

module BuildMaster

describe 'Site' do
  before do
    @system = InMemorySystem.new
    @cotta = Cotta.new(@system)
    @root = @cotta.dir('site')
  end
  
  it 'should build base on content' do
      content_dir = @root.dir('content')
      content_dir.file('index.html').save(<<CONTENT)
<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">    
    <body><h1>Text</h1>
  </body>
</html>
CONTENT
      content_dir.file('markdown.markdown').save(<<CONTENT)
--------------------
markdown title
--------------------
Header
===============
CONTENT

      content_dir.file('textile.textile').save(<<CONTENT)
---------------------
textile title
---------------------
h1. Header
CONTENT
      spec = SiteSpec.new(nil, @cotta)
        spec.output_dir =  'site/output'
        spec.content_dir =  'site/content'
        spec.template =<<TEMPLATE
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:template="http://buildmaster.rubyforge.org/xtemplate/1.0">
  <head>
    <title>Title</title>
  </head>
  <body>
  </body>
</html>
TEMPLATE
      site = Site.new(spec)
      site.build
      expected_output_file = @root.dir('output').file('index.html')
      @root.exists?.should ==(true)
      expected_output_file.exists?.should ==(true)
      
  end
  
  it 'ignore the svn and CVS directories' do
    content_dir = @root.dir('content')
    content_dir.dir('.svn').mkdirs
    content_dir.dir('_svn').mkdirs
    content_dir.dir('CVS').mkdirs
    spec = SiteSpec.new(nil, @cotta)
      spec.output_dir = 'site/output'
      spec.content_dir = 'site/content'
      spec.template = <<TEMPLATE
<html/>      
TEMPLATE
    site = Site.new(spec)
    site.build
    @root.dir('output').list.size.should == 0
  end

  it 'only build if source is out of date' do
    content_dir = @root.dir('content')
    content_dir.file('test.textile').save(<<CONTENT)
---------------
title
---------------
h1. header
CONTENT
    output_dir = @root.file('output/test.html').save('content')
    spec = SiteSpec.new(nil, @cotta)
    spec.output_dir = 'site/output'
    spec.content_dir = 'site/content'
    spec.template = "<html/>"
    Site.new(spec).build
    @root.file('output/test.html').load.should == 'content'
  end
  
  it 'set up site based on the template' do
    templates_dir = @cotta.dir('templates')
    setup_template_choice_one(templates_dir)
    setup_template_choice_two(templates_dir)
    command_io = mock('command line io')
    command_io.should_receive(:puts).exactly(4).times
    command_io.should_receive(:gets).once.and_return('1')
    @cotta.command_interface = CommandInterface.new(command_io)
    spec = SiteSpec.new(nil, @cotta) do |spec|
      spec.content_dir = 'site/content'
      spec.output_dir = 'output'
      spec.template_file = 'site/page_template.html'
    end
    Site.setup(spec, templates_dir)
    spec.template_file.load.should == 'template one'
    spec.content_dir.file('logo.gif').load.should == 'logo one'
  end
  
  def setup_template_choice_one(templates_root)
    root = templates_root.dir('one')
    root.file('template.html').save('template one')
    root.dir('content').file('logo.gif').save('logo one')
  end
  
  def setup_template_choice_two(templates_root)
    root = templates_root.dir('two')
    root.file('template.html').save('template two')
    root.dir('content').file('logo.gif').save('logo two')
  end
    
end

end