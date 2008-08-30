$:.unshift File.dirname(__FILE__)

require 'webrick'
require 'file_processor'

module BuildMaster

class AboutHandler < WEBrick::HTTPServlet::AbstractServlet
# uncomment the following for automatic servlet reloading
#  def SourceFileHandler.get_instance config, *options
#    load __FILE__
#    SourceFileHandler.new config, *options
#  end

  def initialize(server, spec)
    super
    @config = server.config
    @logger = @config[:Logger]
    @spec = spec
  end
  
  def service(req, res)
    content = <<CONTENT
<html>
  <head><title>About BuildMaster</title>
  <body>
    <h1>About <a href="http://buildmaster.rubyforge.org" >BuildMaster</a></h1>
    <pre>
Version       : #{@spec.properties['buildmaster_version']}
Build Number  : #{@spec.properties['buildmaster_buildnumber']}
Licence       : <a href="http://buildmaster.rubyforge.org/license.html">Apache Licence, Version 2.0</a>
  </body>
</html>
CONTENT
    res['content-type'] = 'text/html'
    res['content-length'] = content.length
    res['last-modified'] = DateTime.new
    res.body = content
  end
  
end

end