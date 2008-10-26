gem('rake')

Gem::manage_gems
require 'rake'
require 'spec/rake/spectask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rcov/rcovtask'
require 'specs'

rcov_dir = SITE.output_dir.dir('rcov')
rspec_dir = SITE.output_dir.dir('rspec')

task :init do
  rcov_dir.mkdirs
  rspec_dir.mkdirs
end

#desc "Run all specifications"
Spec::Rake::SpecTask.new(:coverage) do |t|
  t.spec_files = FileList['test/**/tc_*.rb']
  t.rcov = true
  t.rcov_dir = rcov_dir.path
  outputfile = rspec_dir.file('index.html').path
  t.spec_opts = ["--format", "html:#{outputfile}", "--diff"]
  t.fail_on_error = false
end

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.main = "README"
  rdoc.rdoc_files.include("README", "lib/**/*.rb").exclude("lib/buildmaster/site/templatelets/*.rb")
  rdoc.options << "--all"
  rdoc.rdoc_dir = SITE.output_dir.dir('rdoc').path.to_s
end

task :default => [:coverage, :build_site, :rdoc, :package]
task :coverage => [:init]
task :local_install => [:package]

# ??? if we use the rakt gem task, it will somehow be built multiple times and fail???
task :package do
  Gem::manage_gems
  Gem::Builder.new(SPEC).build
end

task :local_install do
  gem_file = SPEC.full_name + ".gem"
  puts "Insalling #{gem_file}..."
  Gem::Installer.new(gem_file).install
end

task :build_site do
  SITE.build
end

task :publish_site do
  output_dir = SITE.output_dir
  raise 'output dir needs to be called the same as the project name for one copy action to work' unless output_dir.name == 'buildmaster'
  BuildMaster::PscpDriver.new("wolfdancer@buildmaster.rubyforge.org").copy(output_dir.path, '/var/www/gforge-projects')
end

task :test_site do
  SITE.test
end

task :serve do
  SITE.server
end

task :deplate do
  require 'deplate/deplate-string'
  puts Deplate::Converter.new('latex').convert_string(BuildMaster::Cotta.file(__FILE__).parent.file('site/content/site/deplate.deplate').load)
end
