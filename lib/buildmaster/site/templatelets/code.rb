module BuildMaster
class Code
  def initialize(site_spec)
    @site_spec = site_spec
  end
  
  def process(target, template, source)
    full_content = load_source_content(source, template)
    tag = template.attributes['tag']
    code_content = full_content
    code_content = load_snippet(full_content, tag) if tag
    syntax = template.attributes['syntax']
    if (syntax)
require 'syntax/convertors/html'
      convertor = Syntax::Convertors::HTML.for_syntax syntax
      pre_tag = REXML::Document.new(convertor.convert(code_content)).root
    else
      pre_tag = REXML::Element.new('pre')
      pre_tag.text = code_content
    end
    pre_tag.attributes['class'] = 'code'
    target.add(pre_tag)
  end
  
  private
  def load_source_content(source, template)
    source_path = template.attributes['source']
    if (source_path)
      return source.file.parent.file(source_path).load
    else
      cdatas = template.cdatas
      raise TemplateError.new(template), 'Either source attribute or CDATA required for source' if cdatas.nil? || cdatas.length == 0
      return cdatas[0].value
    end
  end
  
  def load_snippet(source_content, tag)
    recording = false
    lines = Array.new
    indent = 0
    StringIO.new(source_content).each_line do |line|
      if (line =~ /START #{tag}/)
        recording = true
      elsif (line =~ /END #{tag}/)
        recording = false
      elsif (recording)
        lines.push LineIndent.new(line)
      end
    end
    raise TemplateError, "START #{tag} and END #{tag} not found" if lines.length == 0
    line_with_minimum_indent = lines.select{|line| line.indentation}.min
    minimum_indent = 0
    minimum_indent = line_with_minimum_indent.indentation if line_with_minimum_indent
    text = ''
    lines.each do |line|
      text << line.indent(minimum_indent)
    end
    return text
  end
  
  class LineIndent
    attr_reader :line, :indentation
    
    def initialize(line)
      @line = line.lstrip
      if (@line.empty?)
        @line = line
        @indentation = nil
      else
        @indentation = line.length - @line.length
      end
    end
    
    def indent(indent)
      return @line unless @indentation
      return @line.rjust(@indentation - indent + @line.length)
    end

    def <=>(that)
      indentation <=> that.indentation
    end
  end
end
end