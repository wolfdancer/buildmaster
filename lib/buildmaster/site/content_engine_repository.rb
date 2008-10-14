module BuildMaster
class ContentEngineRepository

  def initialize
    @map = Hash.new
    @map['.textile'] = TextileEngine.new
    @map['.markdown'] = MarkdownEngine.new
    @map['.html'] = HtmlEngine.new
    @map['.txt'] = TextileEngine.new
    @map['.deplate'] = DeplateEngine.new
  end
  
  def supports?(extname)
    @map.has_key?(extname)
  end

  def for_source(source_file)
    @map[source_file.extname]
  end
  
  def for_candidate(directory, basename)
    @map.each_pair do |extname, engine|
      candidate = directory.file("#{basename}#{extname}")
      if candidate.exists?
        return candidate, engine
      end
    end
    return nil, nil
  end
end

module ContentEngine
#todo match only beginning of the file
@@TEXTILE_REGX = /---(-)*\n(.*)\n(-)*---\n/
  def process_content_with_title(full_content)
    match_result = @@TEXTILE_REGX.match(full_content)
    title = ''
    body_content = full_content
    if match_result != nil
      title = match_result[2]
      body_content = match_result.post_match
    end
    html_body = yield body_content
    html_content = <<HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"
  xmlns:template="http://buildmaster.rubyforge.org/xtemplate/1.0">
<head>
  <title>#{title}</title>
</head>
<body>      
    #{html_body}
</body>
</html>
HTML
    return html_content     
  end
end

class TextileEngine
  include ContentEngine
  def convert_to_html(full_content)
require 'redcloth'
    process_content_with_title(full_content) {|content| RedCloth.new(content).to_html}
  end
end

class MarkdownEngine
  include ContentEngine
  def convert_to_html(full_content)
require 'bluecloth'
    process_content_with_title(full_content) {|content| BlueCloth.new(content).to_html}
  end
end

class HtmlEngine
  def convert_to_html(full_content)
    return full_content
  end
end

class DeplateEngine
  include ContentEngine
  def convert_to_html(full_content)
require 'deplate/deplate-string'
    process_content_with_title(full_content) {|content| DeplateString.new(content).to_html}
  end
end
end