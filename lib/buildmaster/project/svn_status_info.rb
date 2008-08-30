require 'rexml/document'
require 'pathname'

module BuildMaster
  class SvnStatusInfo
    def initialize
      @changes = Array.new
    end

    def add(entry)
      @changes.push entry
    end

    def SvnStatusInfo::parse_xml(content)
      info = SvnStatusInfo.new
      xml = REXML::Document.new(content)
      REXML::XPath.each(xml, '/status/target/entry') do |entry|
        info.add Entry.new(entry)
      end
      return info
    end

    def unversioned
      entries('unversioned')
    end

    def missing
      entries('missing')
    end

    def entries(status)
      @changes.select {|entry|
        entry.status == status
      }
    end

    class Entry
      attr_reader :path

      def initialize(element)
        @element = element
        @path = Pathname.new @element.attributes['path']
      end

      def basename
        @path.basename
      end

      def status
        status_element = @element.elements.find {|element|
          element.name == 'wc-status'
        }
        status_element.attributes['item']
      end
    end
  end
end