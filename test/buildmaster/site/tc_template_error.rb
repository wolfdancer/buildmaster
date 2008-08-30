$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'buildmaster')

require 'site/template_error'
require 'spec'

describe 'template error' do
  it 'format of exception' do
    begin
      raise BuildMaster::TemplateError.new('test'), 'message'
      fail('error should have been raised')
    rescue StandardError => error
      $!.to_s.should == 'BuildMaster::TemplateError: message - test'
    end
  end
end