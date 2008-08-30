#import FileUtils
# debian packaging tools.
# 
require 'rake/clean'
CLEAN.include('build')
task :default => [ :clean,:pkg ]
ruby_lib_dir='build/usr/lib/ruby/1.8'
usr_share_doc_dir="build/usr/share/doc"
name="libbuildmaster-ruby"
task :pkg do 
  mkdir_p('build/DEBIAN')
  cp('control','build/DEBIAN')
  mkdir_p(ruby_lib_dir)
  cp_r('../lib/buildmaster',ruby_lib_dir)
  Dir["**/.svn"].each do |f|
    rm_rf(f)
  end
  mkdir_p("build/usr/share/doc/#{name}")
  copy('copyright',"#{usr_share_doc_dir}/#{name}")
  copy('changelog',"#{usr_share_doc_dir}/#{name}")
  fail unless system("gzip -9 #{usr_share_doc_dir}/#{name}/changelog")
  
  fail unless system('fakeroot dpkg-deb -b build')
  fail unless system('lintian -i build.deb')
end
