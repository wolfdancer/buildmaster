$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'buildmaster')

require 'spec'
require 'rexml/xpath'
require 'site/template_builder'
require 'common/tree_to_object'
require 'yaml'

module BuildMaster
describe TemplateBuilder do
  
  it 'should generate template document' do
    builder = TemplateBuilder.new
    document = builder.generate
    REXML::XPath.first(document, '/html/head/title/*').name.should == 'include'
    assert_css_path(document, 'buildmaster.css')
  end
  
  it 'should update header with title and css' do
    builder = TemplateBuilder.new
    builder.title_header = 'Title Header - '
    builder.css_path = 'mycss.css'
    document = builder.generate
    first_child = REXML::XPath.first(document, '/html/head/title').children[0]
    first_child.class.should == REXML::Text
    first_child.value.should == 'Title Header - '
    assert_css_path(document, 'mycss.css')
  end
  
  it 'test_should_have_logo_defaults' do
    builder = TemplateBuilder.new
    builder.logo.path.should == nil
    builder.logo.link.should == 'index.html'
  end
  
  it 'test_should_generate_logo_and_link' do
    builder = TemplateBuilder.new
    builder.logo.path = 'gif/logo.gif'
    builder.logo.link = 'main.html'
    document = builder.generate
    header = assert_first(document, "/html/body/div")
    header.attributes["class"] = 'header'
    anchor_href = assert_first(header, 'a/template:href')
    anchor_href.attributes['url'].should == 'main.html'
    img_href = assert_first(header, 'a/img/template:href')
    img_href.attributes['url'].should == 'gif/logo.gif'
  end
  
  it 'test_should_build_left_menu' do
    builder = TemplateBuilder.new
    builder.left_bottom_logo.path='http://www.example.com/logo.gif'
    group = builder.menu_group('Software')
    group.menu_item('Download', 'download.html')
    group.menu_item('License', 'license.html')
    group.more='more.html'
    group = builder.menu_group('Documentation', 'doc/index.html')
    group.menu_item('Getting Started', 'doc/getting-started')
    document = builder.generate

=begin
XPath support in PEXML does not work anymore...
    groups = REXML::XPath.match(document, '/html/body/div[@class="left"]/div[@class="MenuGroup"]')
    groups.size.should == 2
    first_group = groups[0]
    header = assert_first(first_group, 'h1')
    header.text.should == 'Software'
    items = REXML::XPath.match(first_group, 'ul/li')
    items.size.should == 3
    first_item = items[0]
    anchor = assert_first(first_item, 'template:link')
    anchor.attributes['href'].should == 'download.html'
    anchor.text.should == 'Download'
    more = items[2]
    more.attributes['class'].should == 'More'
=end
  end
  
  it 'should_have_releases_info' do
    builder = TemplateBuilder.new
    releases = builder.releases
    releases.stable_version = '0.6'
    releases.pre_release_version = '0.7'
    releases.snap_shot_version = 'n/a'
    releases.download_link = 'download.html'
    releases.versioning_link = 'versioning.html'
    document = builder.generate

=begin
XPath in REXML does not work anymore
    REXML::XPath.first(document, '/html/body/template:when/div[@class="right"]/div/h1').text.should == 'Latest Versions'

=end

  end
  
  it 'should_have_no_release_info_if_not_assigned' do
    builder = TemplateBuilder.new
    builder.releases.download_link = nil
    document = builder.generate
    REXML::XPath.match(document, '/html/body/template:when/div/*').size.should == 0
  end

  it 'should_read_from_yaml' do
    content = <<CONTENT
title_header: BuilderMaster -
logo:
  path: logo.gif
  link: index.html
menu_groups:
- title: Software
  menu_items:
  - title: Download
    link: download.html
  - title: Source Repository
    link: http://rubyforge.org/scm/?group_id=1680
  - title: Project License
    link: license.html
- title: Documentation...
  link: document.html
  menu_items:
  - title: Getting Started
    link: getting-started.html
  - title: Project Release
    link: release-project.html
  - title: Site Building
    link: build-site.html
  more: doc/index.html
CONTENT
    builder = TreeToObject.from_yaml(content, TemplateBuilder.new)
    builder.title_header.should == 'BuilderMaster -'
    builder.logo.path.should == 'logo.gif'
    builder.logo.link.should == 'index.html'
  end

  private
  def assert_css_path(document, expected)
    href = REXML::XPath.first(document, '/html/head/link/*')
    href.name.should == 'href'
     href.attributes['url'].should == expected
  end  
  
  def assert_first(xml_model, xpath)
    first = REXML::XPath.first(xml_model, xpath)
    first.should_not be_nil
    return first
  end
end
end
