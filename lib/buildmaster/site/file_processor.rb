$:.unshift File.dirname(__FILE__)

require 'site_spec'
require 'source_content'
require 'pathname'

module BuildMaster

class FileProcessor
  
  attr_reader :content_file, :target_file

  def initialize(template, content_file, sitespec)
    @template = template
    @content_file = content_file
    @sitespec = sitespec
    @content_engine = sitespec.content_engines.for_source(content_file)
    if @content_engine
      basename = content_file.basename
      @path = sitespec.relative_to_root(content_file).parent.join("#{basename}.html")
      @target_file = sitespec.output_dir.file(@path)
    else
      @target_file = sitespec.output_dir.file(sitespec.relative_to_root(content_file))
    end
  end
  
  def is_html?
    return target_file.extname == '.html'
  end
  
  def write_to_target
    if (@content_engine)
      document = generate_document
      target_file.write do |file|
        file.puts document.to_s
      end
    else
      content_file.copy_to(target_file)
    end
  end
  
  def generate_document
    if (@content_engine)
      html_content = @content_engine.convert_to_html(content_file.load)
      process_html(html_content)
    end
  end

  def out_of_date?
    (not @target_file.exists?) || @target_file.older_than?(@content_file)
  end

  private
  def process_html(html_content)
    source = SourceContent.new(@path, REXML::Document.new(html_content), content_file)
    source_with_skin = @template.process(source)
    document_with_skin = XTemplate.new(source_with_skin, @sitespec.load_element_processor).process(source)
    return document_with_skin
  end
    
end

end