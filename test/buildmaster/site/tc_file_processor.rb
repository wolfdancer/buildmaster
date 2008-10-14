require 'spec'
require 'rexml/document'
require 'pathname'
require File.dirname(__FILE__) + '/test'

module BuildMaster

describe 'File Processor' do
  before do
    @cotta = Cotta.new(InMemorySystem.new)
    @cotta.file('content').save <<CONTENT
line one
line two
line three
CONTENT
  end
  
  after do
    @cotta = nil
  end

  it 'should know content and target' do
    content = <<CONTENT
<html xmlns="http://www.w3.org/1999/xhtml"
        xmlns:template="http://buildmaster.rubyforge.org/xtemplate/1.0">
</html>
CONTENT
      template = XTemplate.new(REXML::Document.new(content), {})
      site_spec = SiteSpec.new('file.txt', @cotta)
      site_spec.content_dir = 'content'
      site_spec.output_dir = 'output'
      processor = FileProcessor.new(template, @cotta.file('content/index.html'), site_spec)
      processor.content_file.path.should ==(Pathname.new('content/index.html'))
      processor.is_html?.should ==(true)
  end
  
  it 'should copy the content if no content engine found' do
      content = <<CONTENT
<html xmlns="http://www.w3.org/1999/xhtml"
        xmlns:template="http://buildmaster.rubyforge.org/xtemplate/1.0">
</html>
CONTENT
      template = XTemplate.new(REXML::Document.new(content), {})
      site_spec = SiteSpec.new(nil, @cotta)
      current_dir = @cotta.dir('root')
      site_spec.content_dir = 'root/content'
      site_spec.output_dir = 'root/output'
      source = current_dir.dir('content').file('index.gif')
      source.save('content for a gif')
      processor = FileProcessor.new(template, source, site_spec)
      processor.content_file.path.should == source.path
      processor.is_html?.should == false
      processor.write_to_target
      processor.target_file.load.should == source.load
  end
  
  def output_dir
    return @cotta.dir('tmp')
  end
  
  def relative_to_root(path)
    return Pathname.new('tmp')
  end

  it 'should have support for markdown content' do
    template_content = <<CONTENT
<html xmlns="http://www.w3.org/1999/xhtml"
        xmlns:template="http://buildmaster.rubyforge.org/xtemplate/1.0">
<head><title><template:include elements="/html/head/title/text()"/></title></head>
<body>
  <template:include elements="/html/body/*"/>
</body>   
</html>
CONTENT
    hash = {'include' => Include.new(self)}
    template = XTemplate.new(REXML::Document.new(template_content), ElementProcessorByName.new(hash))
    
    sitespec = SiteSpec.new('root', Cotta.new(InMemorySystem.new())) do |spec|
      spec.content_dir = 'content_dir'
      spec.output_dir = 'output_dir'
    end

    source = @cotta.file('content_path.markdown')
    processor = FileProcessor.new(template, source, sitespec)
    source.save(<<CONTENT)
--------------------------------------------
Title Here
--------------------------------------------
Header
=====================
CONTENT
    processor.write_to_target
    document = REXML::Document.new(processor.target_file.load)
    REXML::XPath.first(document, '/html/head/title').get_text.should == 'Title Here'
    REXML::XPath.first(document, '/html/body/h1').get_text.should == 'Header'
  end
  
  it 'should run template engine against resulting content' do
    template_content = <<CONTENT
<html xmlns="http://www.w3.org/1999/xhtml"
        xmlns:template="http://buildmaster.rubyforge.org/xtemplate/1.0">
<head><title><template:include elements="/html/head/title/text()"/></title></head>
<body>
  <template:include elements="/html/body/*"/>
</body>   
</html>
CONTENT
    hash = {'include' => Include.new(self)}
    template = XTemplate.new(REXML::Document.new(template_content), ElementProcessorByName.new(hash))
    
    sitespec = SiteSpec.new('root', Cotta.new(InMemorySystem.new())) do |spec|
      spec.content_dir = 'content_dir'
      spec.output_dir = 'output_dir'
      spec.properties['property'] = 'property value'
    end

    source = @cotta.file('content_path.markdown')
    processor = FileProcessor.new(template, source, sitespec)
    source.save(<<CONTENT)
--------------------------------------------
Title Here
--------------------------------------------
<div>
<template:text property="property"/>
</div>
CONTENT
    processor.write_to_target
    document = REXML::Document.new(processor.target_file.load)
    REXML::XPath.first(document, '/html/head/title').text.should == 'Title Here'
    REXML::XPath.first(document, '/html/body/div').text.strip.should == 'property value'
  end
  
end
end