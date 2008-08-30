require 'spec'

$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'buildmaster')

require 'site/site_spec'
require 'site/site'
require 'site/site_server'
require 'cotta'
require 'cotta/in_memory_system'
require 'project/server_manager'

module BuildMaster
describe 'site server' do
  it 'supports server type' do
  require 'net/http'
    cotta = Cotta.new(InMemorySystem.new)
    root = cotta.dir('/root')
    root.file('content/index.txt').save(<<INDEX)
---
Title
---
h1. Header
INDEX
    template_file = root.file('template.html')
    site_spec = SiteSpec.new(template_file.path, template_file.cotta) do |spec|
      spec.content_dir = 'content'
      spec.output_dir = 'output'
      spec.template_file = template_file.name
    end
    site_spec.template_file.save(<<TEMPLATE)
<html>template content</html>
TEMPLATE
    server = SiteServer.new(site_spec, 8882)
    puts 'checking server status'
    puts "running #{server.running?}"
    manager = ServerManager.new(server)
    manager.start
    manager.stop
    server.running?.should == false
  end
end
end
    