$:.unshift File.dirname(__FILE__)

require 'rubygems'
Gem::manage_gems
require 'rake'
require 'build_master_site'
require 'lib/buildmaster/cotta'
require 'lib/buildmaster/project'

root = BuildMaster::Cotta.parent_of(__FILE__)
VERSION_NUMBER = BuildMaster::VersionNumberFile.new(root.file('lib/buildmaster/version'))
site_spec = BuildMasterSite.new(__FILE__) do |spec|
  spec.output_dir = 'build/website/buildmaster'
  spec.content_dir = 'site/content'
  spec.template_file = 'site/template.html'
  spec.properties['release']= '1.1.9'
  spec.properties['prerelease']= 'n/a'
  spec.properties['news_rss2'] = spec.content_dir.file('news-rss2.xml').load
  spec.properties['snapshot'] = VERSION_NUMBER.version_number
end
SITE = BuildMaster::Site.new(site_spec)


SPEC = Gem::Specification.new do |spec|
  spec.name = 'BuildMaster'
  spec.version = VERSION_NUMBER.version_number
  spec.author = 'Shane Duan'
  spec.email = 'buildmaster@googlegroups.com'
  spec.homepage = 'http://buildmaster.rubyforge.org/'
  spec.platform = Gem::Platform::RUBY
  spec.summary = 'A project that hosts a series of scripts to be used for project release and depolyment, static website building, and file operations.'
  spec.files = FileList["{bin,docs,lib,test}/**/*"].exclude("rdoc").to_a
  spec.require_path = 'lib'
  spec.autorequire = 'buildmaster/cotta'
  spec.has_rdoc = true
  spec.rubyforge_project = 'buildmaster'
  spec.extra_rdoc_files = ["README"]
end
