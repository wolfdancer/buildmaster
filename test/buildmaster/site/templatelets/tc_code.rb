require File.dirname(__FILE__) + '../../test'

require File.dirname(__FILE__) + '/common_templatelet_test'

module BuildMaster
describe 'code template processsing' do
  include HelperMethods
  
  before do
    @cotta = Cotta.new(InMemorySystem.new)
  end
  
  it 'generate <pre> tag with code class by default' do
    template_content = <<CONTENT
<html>
<code source="samples/sample.rb" tag="sample"/>
</html>
CONTENT
    content_path = 'doc/doc.html'
    @cotta.file(content_path).parent.file('samples/sample.rb').save <<CONTENT
#START sample

# Normally you would put release script at the root of the project
cotta = BuildMaster::Cotta.new
root = cotta.file(__FILE__).parent

# BuildMaster can look into svn files to figure out the svn information
#END sample
CONTENT
    target = create_element('test')
    template = create_template_element(template_content, '/html/code')
    site_spec = SiteSpec.new('/root', @cotta);
    code_processor = Code.new(site_spec)
    code_processor.process(target, template, SourceContent.new('doc/doc.html', nil, @cotta.file(content_path)))
    REXML::XPath.first(target, 'pre').attributes['class'].should == 'code'
    REXML::XPath.first(target, 'pre').text.should == <<CONTENT

# Normally you would put release script at the root of the project
cotta = BuildMaster::Cotta.new
root = cotta.file(__FILE__).parent

# BuildMaster can look into svn files to figure out the svn information
CONTENT
  end

  it 'handle the case of only blank lines' do
    template_content = <<CONTENT
<html>
<code source="samples/sample.rb" tag="sample"/>
</html>
CONTENT
    content_path = 'doc/doc.html'
    @cotta.file(content_path).parent.file('samples/sample.rb').save <<CONTENT
#START sample


#END sample
CONTENT
    target = create_element('test')
    template = create_template_element(template_content, '/html/code')
    site_spec = SiteSpec.new('/root', @cotta);
    code_processor = Code.new(site_spec)
    code_processor.process(target, template, SourceContent.new('doc/doc.html', nil, @cotta.file(content_path)))
    REXML::XPath.first(target, 'pre').attributes['class'].should == 'code'
    REXML::XPath.first(target, 'pre').text.should == <<CONTENT


CONTENT
  end


  it 'generate error if none found' do
    template_content = <<CONTENT
<html>
<code source="samples/sample.rb" tag="sample"/>
</html>
CONTENT
    content_path = 'doc/doc.html'
    @cotta.file(content_path).parent.file('samples/sample.rb').save
    target = create_element('test')
    template = create_template_element(template_content, '/html/code')
    site_spec = SiteSpec.new('/root', @cotta);
    code_processor = Code.new(site_spec)
    source = SourceContent.new('doc/doc.html', nil, @cotta.file(content_path))
    Proc.new {code_processor.process(target, template, source)}.should raise_error(TemplateError)
  end
  
  it 'use PCDATA if no source specified' do
    template_content = <<CONTENT
<html>
<code tag="sample">
<![CDATA[
module BuildMaster

#START sample
class test
end
#END sample
end
]]>
</code>
</html>
CONTENT
    content_path = 'doc/doc.html'
    target = create_element('test')
    template = create_template_element(template_content, '/html/code')
    site_spec = SiteSpec.new('/root', @cotta);
    code_processor = Code.new(site_spec)
    code_processor.process(target, template, SourceContent.new('doc/doc.html', nil, @cotta.file(content_path)))
    REXML::XPath.first(target, 'pre').attributes['class'].should == 'code'
    REXML::XPath.first(target, 'pre').text.should == <<CONTENT
class test
end
CONTENT
  end
  
  it 'raise error if no source and no pcdata' do
    template_content = <<CONTENT
<html>
<code tag="sample">
</code>
</html>
CONTENT
    content_path = 'doc/doc.html'
    target = create_element('test')
    template = create_template_element(template_content, '/html/code')
    site_spec = SiteSpec.new('/root', @cotta);
    code_processor = Code.new(site_spec)
    source = SourceContent.new('doc/doc.html', nil, @cotta.file(content_path))
    Proc.new{code_processor.process(target, template, source)}.should raise_error(TemplateError)
  end
  
  it 'generate syntax support' do
    template_content = <<CONTENT
<html>
<code source="samples/sample.rb" tag="sample" syntax="ruby"/>
</html>
CONTENT
    content_path = 'doc/doc.html'
    @cotta.file(content_path).parent.file('samples/sample.rb').save <<CONTENT
#START sample
module BuildMaster

class test
end
end
#END sample
CONTENT
    target = create_element('test')
    template = create_template_element(template_content, '/html/code')
    site_spec = SiteSpec.new('/root', @cotta);
    code_processor = Code.new(site_spec)
    code_processor.process(target, template, SourceContent.new('doc/doc.html', nil, @cotta.file(content_path)))
    REXML::XPath.first(target, 'pre').attributes['class'].should == 'code'
    REXML::XPath.first(target, 'pre/span').attributes['class'].should == 'keyword'
  end
end
end
