require 'spec'
require File.dirname(__FILE__) + '/../test'
require File.dirname(__FILE__) + '/common_templatelet_test'

module BuildMaster
describe 'HrefTest' do
  include HelperMethods
  before do
    setup_spec
    @template_element = create_element('href')
    @target_element = create_element('a')
    @href = Href.new(@site_spec)
  end  
  
  def source(path)
    SourceContent.new(Pathname.new(path), nil, nil)
  end

  it 'should_populate_href_attribute_with_full_url' do
    expected_url = 'http://www.rubyforge.org'
    @template_element.attributes['url']=expected_url
    @href.process(@target_element, @template_element, source('index.html'))
    @target_element.attributes['href'].should == expected_url
  end
  
  it 'should_populate_href_attribute_with_relative_path' do
    @template_element.attributes['url']='doc/doc.html'
    @href.process(@target_element, @template_element, source('download/index.html'))
    @target_element.attributes['href'].should == '../doc/doc.html'
  end
  
  it 'should_support_image_tag_by_generating_src_attribute' do
    @template_element.attributes['url']='doc/doc.gif'
    @target_element = create_element('img')
    @href.process(@target_element, @template_element, source('download/download.html'))
    @target_element.attributes['src'].should == '../doc/doc.gif'
  end
  
  it 'should_handle_external_links' do
    @template_element.attributes['url'] = 'http://www.google.com'
    @target_element = create_element('img')
    @href.process(@target_element, @template_element, source('download/download.html'))
    @target_element.attributes['src'].should == 'http://www.google.com'
  end

  it 'should_handle_absolute_path' do
    @template_element.attributes['url'] = '/doc.html'
    @target_element = create_element('img')
    @href.process(@target_element, @template_element, source('download/download.html'))
    @target_element.attributes['src'].should == '../doc.html'
  end
  
end
end
