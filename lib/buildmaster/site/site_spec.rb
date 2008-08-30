require 'pathname'
$:.unshift File.join(File.dirname(__FILE__), '..', '..')
require 'common'
require 'cotta'

$:.unshift File.dirname(__FILE__)
require 'templatelets'
require 'template_builder'
require 'element_processor_by_name'
require 'xtemplate'
require 'project/build_number_file'
require 'content_engine_repository'


module BuildMaster

  class SiteSpec
    attr_reader :output_dir, :content_engines, :cotta, :properties
    attr_accessor :content_dir, :template, :template_file, :content_format, :txt_format
    
    def initialize(file_at_root = nil, cotta = Cotta.new())
      @root = cotta.file(file_at_root).parent if file_at_root
      @cotta = cotta
      @content_engines = ContentEngineRepository.new
      if (block_given?)
        yield self
      end
    end
    
    def output_dir=(path)
      @output_dir = to_cotta_dir(path)
    end
    
    def content_dir=(path)
      @content_dir = to_cotta_dir(path)
    end
    
    def template_file=(path)
      @template_file = @root.file(path) if @root
      @template_file = @cotta.file(path)
    end
    
    def to_cotta_dir(path)
      return @root.dir(path) if @root
      return @cotta.dir(path)
    end
    
    private :to_cotta_dir
    
    def page_layout=(yaml)
      @template = TreeToObject.from_yaml(yaml, TemplateBuilder.new).content
    end
    
    def properties
      unless @properties
        @properties = Hash.new unless @properties
        @properties['buildmaster_version'] = Cotta.parent_of(__FILE__).parent.file('version').load.strip
      end
      return @properties
    end
    
    def validate_inputs
      validate_dir(content_dir, :content_dir)
    end
    
    def load_template
      templatelets = load_templatelets
      template_source = load_template_source
      return XTemplate.new(REXML::Document.new(template_source), load_element_processor)
    end
    
    def load_element_processor
      ElementProcessorByName.new(load_templatelets)
    end
    
    def load_templatelets
      hash = Hash.new
      hash['href'] = Href.new(self)
      hash['attribute'] = Attribute.new(self, properties)
      hash['each'] = Each.new(self)
      hash['include'] = Include.new(self)
      hash['link'] = Link.new(self)
      hash['text'] = Text.new(properties)
      hash['when'] = When.new(self, self)
      hash['code'] = Code.new(self)
      return hash
    end
    
    def load_template_source
      if (@template)
        return @template
      else
        return @template_file.load
      end
    end
    
    def load_document(path)
      content_dir.file(path).read {|file| REXML::Document.new(file)}
    end

    def relative_to_root(path)
      to = path_name(path.path.to_s)
      from = path_name(@content_dir.path.to_s)
      return to.relative_path_from(from)
    end

    # deprecated, use properties
    def add_property(name, value)
      properties()[name] = value
    end

   def center_class(content_path)
    if index_file? content_path
      return 'Content3Column'
    else
      return 'Content2Column'
    end
  end

  def index_file?(source)
    result = source.path.to_s == 'index.html'
    return result
  end
  
  def version(source)
  end
  
  def build(source)
  end
  
  private
  def path_name(path)
    return Pathname.new(path.gsub(/\\/, '/'))
  end
  
  def validate_dir(directory, symbol)
    if not directory
      raise "Directory for #{symbol.id2name} not specified"
    end
    if not directory.exists?
      raise "Directory for #{symbol.id2name} -- <#{directory}> does not exist"
    end
    if not directory.exists?
      raise "<#{directory}> should be a directory for #{symbol.id2name}"
    end
  end
 
    
=begin
    def validate_file(file, symbol)
      if not file
        raise "File for #{symbol.id2name} not specified"
      end
      if (not File.exists? file)
        raise "File for #{symbol.id2name} -- <#{file}> does not exist"
      end
      if not File.file? file
        raise "#<{file} should be a file for #{symbol.id2name}"
      end
    end
=end
  end
  
end