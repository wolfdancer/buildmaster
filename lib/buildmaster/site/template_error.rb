$:.unshift File.dirname(__FILE__)

module BuildMaster

  class TemplateError < StandardError
    attr_reader :element
    
    def initialize(element)
      @element = element
    end
    
    def to_s
      "#{self.class}: #{super} - #{@element}"
    end
    
  end

end