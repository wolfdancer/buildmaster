root = File.dirname(__FILE__)

require root + '/lib/buildmaster/site'
require root + '/lib/buildmaster/cotta'

class BuildMasterSite < BuildMaster::SiteSpec  
  def history(content_path)
    return content_path
  end
  
  def doc_source_url(source)
    return "http://rubyforge.org/cgi-bin/viewvc.cgi/trunk/site/content/#{relative_to_root(source.file)}?root=buildmaster&view=co"
  end
  
  def doc_history_url(source)
    return "http://rubyforge.org/cgi-bin/viewvc.cgi/trunk/site/content/#{relative_to_root(source.file)}?root=buildmaster&view=log"
  end
  
end
