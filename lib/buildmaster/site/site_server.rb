$:.unshift File.dirname(__FILE__)

require 'webrick'
require 'source_file_handler'
require 'about_handler'
require 'net/http'

module BuildMaster
class SiteServer
    def initialize(spec, port_number=2000, log_file=$stdout, level=WEBrick::Log::INFO, access_log=nil)
      @spec = spec
      @port_number = port_number
      @log_file = log_file
      @level = level
      @access_log = access_log
    end  
    
    def start
      puts 'starting server...'
      mime_types = WEBrick::HTTPUtils::DefaultMimeTypes.update(
        {"textile" => "text/plain", 'markdown' => 'text/plain'}
      )
      @server = WEBrick::HTTPServer.new(
        :Port => @port_number,
        :Logger => WEBrick::Log.new(@log_file, @level),
        :MimeTypes => mime_types,
        :AccessLog => @access_log
      )
      @server.mount('/', SourceFileHandler, @spec)
      @server.mount('/source', WEBrick::HTTPServlet::FileHandler, @spec.content_dir.path, true)
      @server.mount('/about', AboutHandler, @spec)
      @server.start
    end
    
    def stop
      @started = false
      @server.shutdown
    end
    
    def running?
      return false unless @server
      url = URI.parse("http://localhost:#{@port_number}/")
      request = Net::HTTP::Get.new(url.path)
      begin
        res = Net::HTTP.start(url.host, url.port) {|http|
          http.read_timeout=5
          http.request(request)
        }
        puts "response: #{res}"
      rescue Errno::EBADF, Errno::ECONNREFUSED => e
        return false
      end 
      return true      
    end
end
end
