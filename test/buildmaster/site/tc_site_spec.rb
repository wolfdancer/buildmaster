require 'spec'
require File.dirname(__FILE__) + '/test'

module BuildMaster

describe 'Site Specification' do
  before do
    @cotta = Cotta.new(InMemorySystem.new)
  end

  it 'get relative path' do
    spec = SiteSpec.new(nil, @cotta)
    spec.content_dir = '/one/two/content'
    spec.relative_to_root(@cotta.file('/one/two/content/images/logo.gif')).to_s.should ==('images/logo.gif')
  end
  
  it 'supports windows path' do
    spec = SiteSpec.new(nil, @cotta)
    spec.content_dir = 'C:\Work\project\content'
    spec.relative_to_root(@cotta.file('C:\Work\project\content\images\logo.gif')).to_s.should ==('images/logo.gif')
  end
  
  it 'initialization with block' do
    spec = SiteSpec.new(__FILE__, @cotta) do |sitespec|
      sitespec.content_dir = 'content'
      sitespec.output_dir = 'output'
      sitespec.page_layout = <<CONTENT
title_header: BuildMaster - 
css_path: css.css
logo:
  path: logo.gif
  link: index.html
menu_groups:
- title: first menu group
  menu_items:
  - title: item one for g1
    link: item_one.html
  - title: item two for g2
    link: item_two.html
- title: second menu group
CONTENT
    end
    root = @cotta.dir(__FILE__).parent
    spec.content_dir.should ==(root.dir('content'))
    spec.output_dir.should ==(root.dir('output'))
    spec.load_template_source.to_s.include?('first menu group').should == true
  end

  it 'add property through [] notation' do
    spec = SiteSpec.new(__FILE__, @cotta) do |sitespec|
      sitespec.properties['name']='value'
    end
    spec.properties['name'].should == 'value'
  end
  
end

end