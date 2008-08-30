module BuildMaster

require 'watir'
require 'set'
require 'uri'

class SiteTester
  URL_PATTERN = /^https?\:\/\/([^\/]*)/

  def SiteTester.test(url)
    for_url(url, true).start
  end
  
  def SiteTester.test_offline(url)
    for_url(url, false).start
  end

  def SiteTester.for_url(url, check_external_link)
    ie = Watir::IE.start(url)
    return SiteTester.new(ie, check_external_link)
  end

  def initialize(ie, check_external_link)
    @ie = ie
    @host = get_host(@ie.url)
    @errors = Hash.new
    @visited_pages = Set.new
    @check_external_link = check_external_link
  end
   
  def start
    check_page
    @ie.close
    if (@errors.size == 0)
      puts "SUCCESS: NO BROKEN LINK FOUND"
    else
      puts "FAILED"
    end
  end
  
  private
  def get_host(url)
    url =~ URL_PATTERN
    return $1
  end
  
  def check_page
    if (url_visited?(@ie.url))
      return
    end
    check_links
    errors = @errors[@ie.url]
    if (errors && errors.length > 0)
      report(@ie.url, errors)
    end
  end
  
  def url_visited?(url)
    index = url.index('#')
    if (index)
      url = url[0, index]
    end
    if (@visited_pages.include?(url))
      return true
    end
    @visited_pages.add(url)
    return false
  end
  
  def check_links
    current = @ie.url
    @ie.links.each do |link|
      if (@host == get_host(link.href))
        click_link(link) {check_page}
      elsif (@check_external_link == true)
        click_link(link) { }
      else
        flash(link)
        next
      end
      go_back(current)
    end
  end
  
  def go_back(expected_url)
    @ie.goto(expected_url)
  end
  
  def log
      yield
  end
  
  def flash(element)
    element.flash
  end
  
  def click_link(link)
    from_location = @ie.url
    link_string = link.to_s
    begin
        link.click
        yield
    rescue Watir::Exception::NavigationException => e
      register_broken_link(from_location, link_string)
    end
  end
  
  def flash(link) #copied from watir because it is private there
    ole = link.getOLEObject
    original_color = ole.style.backgroundColor
    high_light(ole, 'yellow')
    high_light(ole, original_color)
  end
  
  def high_light(ole_object, color)
    ole_object.style.backgroundColor = color
    sleep(0.05)
  end
  
  def register_broken_link(from_location, link_string)
    links = @errors[from_location]
    if (not links)
      links = []
      @errors[from_location] = links
    end
    links.push(link_string)
  end
  
  def report(url, links)
    puts "#{url}"
    puts "--------------------------------"
    links.each do |link|
      puts "#{link}"
      puts "--------------------------------"
    end
    puts "################################"
  end
  
end

end