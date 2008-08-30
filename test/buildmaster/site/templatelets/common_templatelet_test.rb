$:.unshift File.join(File.dirname(__FILE__), "..", "..", "..", '..', "lib", 'buildmaster')

require 'rexml/xpath'
require 'rexml/document'
require 'spec'
require 'site/site_spec'
require 'site/source_content'
require 'site/template_error'
require 'site/templatelets'
require 'cotta'
require 'cotta/in_memory_system'

module BuildMaster
module HelperMethods

  def setup_spec
    @cotta = Cotta.new(InMemorySystem.new)
    @site_spec = BuildMaster::SiteSpec.new(nil, @cotta)
    @site_spec.content_dir = '/tmp/workingdir/content'
  end
  
  def create_element(name)
    element = REXML::Element.new
    element.name=name
    return element
  end
  
  def create_template_element(content, xpath)
    REXML::XPath.first(REXML::Document.new(content), xpath)
  end
end
end