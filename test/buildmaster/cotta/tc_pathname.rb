$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'buildmaster')
require 'spec'

require 'cotta'

describe Pathname do
  it 'parent check for unix path' do
    pathname = Pathname.new('/')
    pathname.cotta_parent.should be_nil
  end
  
  it 'parent check for windows path' do
    pathname = Pathname.new('D:/')
    pathname.cotta_parent.should be_nil
  end
  
  it 'parent check for normal ppl' do
    pathname = Pathname.new('/test')
    pathname.cotta_parent.should == Pathname.new('/')
  end
  
end
