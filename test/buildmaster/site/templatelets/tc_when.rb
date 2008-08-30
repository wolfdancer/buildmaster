$:.unshift File.dirname(__FILE__)

require 'common_templatelet_test'

module BuildMaster
describe 'WhenTest' do
  include HelperMethods
  
  before do
    setup_spec
  end

  it 'should_process_child_when_evaluated_true' do
    target = create_element('target')
    template_content = <<CONTENT
<when test='expression_for_true'>
  <h1>Header</h1>
</when>
CONTENT
    sitespec_mock = mock('SiteSpec')
    sitespec_mock.should_receive(:load_element_processor).once.with(no_args()).and_return(nil)
    template_document = REXML::Document.new(template_content)
    template = REXML::XPath.first(template_document, '/when')
    when_processor = When.new(sitespec_mock, self)
    when_processor.process(target, template, self)
    actual = REXML::XPath.first(target, 'h1')
    actual.text.should == 'Header'
  end
  
  it 'should_not_process_child_when_evaluated_false' do
    target = create_element('target')
    template_content = <<CONTENT
<when test='expression_for_false'>
  <h1>Header</h1>
</when>
CONTENT
    sitespec_mock = mock('SiteSpec')

    template_document = REXML::Document.new(template_content)
    template = REXML::XPath.first(template_document, '/when')
    when_processor = When.new(sitespec_mock, self)
    when_processor.process(target, template, self)
    target.size.should == 0
  end
  
  def path
    return Pathname.new('index.html')
  end
  
  def expression_for_true(path)
    return 'word two' =~ /word/
  end
  
  def expression_for_false(path)
    return 'one word two' =~ /nomatch/
  end
end
end
