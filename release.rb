$:.unshift File.join(File.dirname(__FILE__), 'lib', 'buildmaster')

require 'project'
require 'cotta'
require 'specs'
require 'rake'

root = BuildMaster::Cotta.file(__FILE__).parent
doc_zip = root.file("#{SPEC.name}-doc.tar.zip")
svn = BuildMaster::SvnDriver.from_path(root)

release = BuildMaster::Release.new
release.task('version') do
  VERSION_NUMBER.increase_build
  SPEC.version = VERSION_NUMBER.version_number
end
release.task("rake") do
  load 'rake'
#  rake = Rake::Application.new
#  rake.options.rakefile = root.file('rakefile.rb').path
#  rake.options.trace = true
#  rake.run
end
release.task('commit') {svn.commit('committing before release')}
release.task('tagging') do
  tag = "buildmaster-#{SPEC.version}"
  puts "tagging with #{tag}"
  svn.tag(tag)
end

release.task("doc") do
  output_dir = SITE.output_dir
  output_dir.archive.zip.move_to(doc_zip)
end

release.task("upload") do
  gem = "#{SPEC.name}-#{SPEC.version}"
  target_path = "/var/www/gforge-projects/buildmaster/builds/"
  BuildMaster::PscpDriver.new("#{svn.user}@buildmaster.rubyforge.org").copy(root.file("#{gem}.gem").to_s, "#{target_path}#{gem}.gem")
  BuildMaster::PscpDriver.new("#{svn.user}@buildmaster.rubyforge.org").copy(doc_zip.to_s, "#{target_path}#{SPEC.name}-#{SPEC.version}-doc.tar.zip")
end

release.command(ARGV)