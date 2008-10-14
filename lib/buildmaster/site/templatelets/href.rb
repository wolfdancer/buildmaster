require 'uri'

module BuildMaster

class Href
  def initialize(site_spec)
    @site_spec = site_spec
  end
  
  def process(target, template, source)
    url = template.attribute_value!('url')
    href = construct_href(url, source.path)
    target.attributes[name_based_on_target(target)] = href
  end
  
  private
  def construct_href(url, current_path)
    href = url
    if (URI.parse(url).scheme.nil?)
      path = Pathname.new(url)
      if (not path.relative?)
        path = path.relative_path_from(Pathname.new('/'))
      end
      href = path.relative_path_from(current_path.parent).to_s
    end  
    return href
  end
  
  def name_based_on_target(target)
    name = target.name
    if (name == 'img')
      return 'src'
    else
      return 'href'
    end
  end
end
end
