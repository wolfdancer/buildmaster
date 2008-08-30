$:.unshift File.dirname(__FILE__)

require 'common_templatelet_test'

module BuildMaster

class MySite < SiteSpec
  def load_document(path)
    content =  <<CONTENT
<rss>
  <item>
    <title>Title One</title>
    <pubDate>Today</pubDate>
  </item>
  <item>
    <title>Title Two</title>
    <pubDate>Tomorrow</pubDate>
  </item>
</rss>
CONTENT

    return REXML::Document.new(content)
  end
end

describe 'EachTest' do
  include HelperMethods
  it 'should_iteration_through_selected_elements' do
    template_content = <<CONTENT
<each source="rss" select="/rss/item" count="2">
  <div class="NewsItem">
    <p class="Title"><include elements="./title/text()"/></p>
    <p class="Date"><include elements="./pubDate/text()"/></p>
  </div>
</each>
CONTENT
    target = create_element('test')
    template = create_template_element(template_content, '/each')
    site = MySite.new(@site_spec, @cotta)
    each_processor = Each.new(site)
    each_processor.process(target, template, SourceContent.new('doc/doc.html', nil, nil))
    REXML::XPath.first(target, 'div').attributes['class'].should == 'NewsItem'
    REXML::XPath.match(target, 'div').size.should == 2
  end
  
  it 'handles the case where there are not enough items' do
    template_content = <<CONTENT
<each source="rss" select="/rss/item" count="4">
  <div class="NewsItem">
    <p class="Title"><include elements="./title/text()"/></p>
    <p class="Date"><include elements="./pubDate/text()"/></p>
  </div>
</each>
CONTENT
    target = create_element('test')
    template = create_template_element(template_content, '/each')
    site = MySite.new(@site_spec, @cotta)
    each_processor = Each.new(site)
    each_processor.process(target, template, SourceContent.new('doc/doc.html', nil, nil))
    REXML::XPath.first(target, 'div').attributes['class'].should == 'NewsItem'
    REXML::XPath.match(target, 'div').size.should == 2
  end
  
  def on_line_test_rss_uri_need_start_a_server
    template_content = <<CONTENT
<each source="http://localhost:2000/news-rss2.xml" select="/rss/item" count="2">
  <div class="NewsItem">
    <p class="Title"><include elements="./title/text()"/></p>
    <p class="Date"><include elements="./pubDate/text()"/></p>
  </div>
</each>
CONTENT
    target = create_element('test')
    template = REXML::XPath.first(REXML::Document.new(template_content), '/each')
    site = MySite.new
    each_processor = Each.new(site)
    each_processor.process(target, template, SourceContent.new('doc/doc.html', nil, nil))
    REXML::XPath.first(target, 'div').attributes['class'].should == 'NewsItem'
    REXML::XPath.match(target, 'div').size.should == 2
  end
end

end