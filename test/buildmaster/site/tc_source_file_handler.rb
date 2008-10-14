require 'spec'
require 'webrick'
require File.dirname(__FILE__) + '/test'

module BuildMaster

describe 'SourceFileHandler' do
  attr_reader :path_info

  it 'should_be_able_to_find_source' do
    server = WEBrick::HTTPServer.new(:Port => 2001)
    current_file = Cotta.file(__FILE__)
    dir = current_file.parent
    spec = SiteSpec.new
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
    spec.content_dir = dir.dir('content').path
    spec.output_dir = dir.dir('output').path
    file_handler = SourceFileHandler.new(server, spec)
    @path_info = '/markdown.markdown'
    file_handler.service(self, self)
    document = REXML::Document.new(self['body'])
    REXML::XPath.first(document, '/html/head/title').text.should == 'Title'
  end
  
  def []=(name, value)
    logged_properties[name] = value
  end
  
  def [](name)
    logged_properties[name]
  end
  
  def logged_properties
    @logged_properties = Hash.new unless (@logged_properties)
    return @logged_properties
  end
  
  def body=(value)
    self['body']=value
  end
  
end

end