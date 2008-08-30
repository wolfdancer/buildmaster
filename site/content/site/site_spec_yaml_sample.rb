#START site spec sample
require 'buildmaster'

# page layout in YAML
PAGE_LAYOUT = <<CONTENT
title_header: HTML Title - 
css_path: path_to_css_file.css
logo:
  text: Fitnesse Task
menu_groups:
  - title: Software
    menu_items:
    - title: Download
      link: download.html
    - title: License
      link: license.html
CONTENT

# site spec regarding the content directory, output directory and page layout
SITE_SPEC = BuildMaster::SiteSpec.new(__FILE__) do |spec|
  spec.output_dir = 'output'
  spec.content_dir = 'docs'
  spec.page_layout = PAGE_LAYOUT
end

site = BuildMaster::Site.new(SITE_SPEC)
site.execute(ARGV)
#END site spec sample