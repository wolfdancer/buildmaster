require 'spec'
require File.dirname(__FILE__) + '/../test'

module BuildMaster

describe JavaManifest do
  before do
    @cotta = Cotta.new(InMemorySystem.new)
  end
  
  after do
    @cotta = nil
  end

  it 'loading_manifest' do
    file = @cotta.file('dir/manifest.mf')
    file.save <<CONTENT
Implementation-Version: 2.3.3
Implementation-Build: 1139

Implementation-Vendor: Vendor
Implementation-Number: Number
CONTENT
    manifest = JavaManifest.new(file)
    version = manifest.version
    "2.3.3".should == version.number
  end
  
  it 'increase_build' do
    file = @cotta.file('dir/manifest.mf')
    file.save <<CONTENT
Implementation-Version: 2.3.3
Implementation-Build: 1139

Implementation-Vendor: Vendor
Implementation-Number: Number
CONTENT
    manifest = JavaManifest.new(file)
    build_number = manifest.version.build
    version = manifest.increase_build
    (build_number + 1).should == version.build
    manifest.version.build.should == version.build
  end
end
end