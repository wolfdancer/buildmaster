$:.unshift File.dirname(__FILE__)

require 'webrick'
require 'file_processor'

module BuildMaster

class SourceFileHandler < WEBrick::HTTPServlet::AbstractServlet
# uncomment the following for automatic servlet reloading
#  def SourceFileHandler.get_instance config, *options
#    load __FILE__
#    SourceFileHandler.new config, *options
#  end

  def initialize(server, spec)
    super
    @config = server.config
    @logger = @config[:Logger]
    @spec = spec
    @delegate = WEBrick::HTTPServlet::FileHandler.new(server, spec.content_dir.path, true)
  end
  
  def service(req, res)
    path = req.path_info
    file_processor = for_request_path(path)
    if (file_processor)
      begin
        content = file_processor.generate_document.to_s
      rescue Exception
        @logger.error("error serving the file #{path}")
        @logger.error($!)
        raise WEBrick::HTTPStatus::InternalServerError, 
          "#{$!}", caller
      end
      res['content-type'] = 'text/html'
      res['content-length'] = content.length
      res['last-modified'] = DateTime.new
      res.body = content
    else
      @delegate.service(req, res)
    end
  end
  
  private
  def for_request_path(request_path)
    template = @spec.load_template
    if (request_path[0,1] == '/')
      request_path = request_path[1, request_path.length - 1]
    end
    file = @spec.content_dir.file(request_path)
    processor = nil
    if (@spec.content_engines.supports?(file.extname))
      source, content_engine = @spec.content_engines.for_candidate(file.parent, file.basename)
      processor = FileProcessor.new(template, source, @spec) if source #todo test this if condition
    end
    return processor
  end
end

end