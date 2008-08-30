require 'rexml/document'
require 'rexml/xpath'

module BuildMaster
class Logo
  attr_accessor :path, :link, :text
  
  def initialize
    @link = 'index.html'
    @text = 'logo'
  end
end

class MenuGroup
  attr_reader :title, :link, :items, :more
  attr_writer :title, :link, :more
  
  def initialize(title, link)
    @title = title
    @link = link
    @items = Array.new
  end

  def add_to_menu_items
    item = MenuItem.new('item', nil)
    @items.push(item)
    return item
  end
  
  def menu_item(title, link)
    add_item(MenuItem.new(title, link))
  end
  
  def add_item(item)
    @items.push(item)
  end
  
end

class MenuItem
  attr_reader :title, :link
  attr_writer :title, :link
  
  def initialize(title, link)
    @title = title
    @link = link
  end
end

class Releases
  attr_reader :stable_version, :pre_release_version, :snap_shot_version, :download_link, :versioning_link
  attr_writer :stable_version, :pre_release_version, :snap_shot_version, :download_link, :versioning_link
  
  def initialize
    @pre_release_version = 'n/a'
    @snap_shot_version = 'n/a'
    @versioning_link = 'versioning.html'
  end
end

class TemplateBuilder
  attr_accessor :title_header, :css_path, :news_rss, :contact_admin
  attr_reader :logo, :menu_groups
  
  def initialize
    @title_header = ''
    @css_path = 'buildmaster.css'
    @logo = Logo.new
    @menu_groups = Array.new
    @contact_admin = 'contact.html'
  end

  def add_to_menu_groups
    group = MenuGroup.new('group', nil)
    menu_groups.push(group)
    return group
  end
  
  def menu_group(title, link = nil)
    group = MenuGroup.new(title, link)
    menu_groups.push(group)
    return group
  end
  
  def left_bottom_logo
    if (@left_bottom_logo.nil?)
      @left_bottom_logo = Logo.new
    end
    return @left_bottom_logo
  end
  
  def releases
    if (@releases.nil?)
      @releases = Releases.new
    end
    return @releases
  end
  
  def generate
    return load_template
  end
  
  def content
    return load_template_content
  end

  private 
  def load_template
    content = load_template_content
    return REXML::Document.new(content)
  end
  
  def generate_logo_text
    if (logo.path)
      return "<img id=\"logo\" alt=\"#{logo.text}\"><template:href url=\"#{logo.path}\"/></img>"
    else
      return logo.text
    end
  end
  
  def generate_menu_groups
    result = ""
    menu_groups.each do |menu_group|
      menu_group_content = <<CONTENT
      <div class="MenuGroup">
        <h1>#{generate_menu_group_content(menu_group)}</h1>
        <ul>
          #{generate_menu_group_item_content(menu_group.items)}
          #{generate_more_item(menu_group.more)}
        </ul>
      </div>
CONTENT
      result += menu_group_content
    end
    return result
  end
  
  def generate_menu_group_content(menu_group)
    if (menu_group.link)
      return "<template:link href=\"#{menu_group.link}\">#{menu_group.title}</template:link>"
    else
      return menu_group.title
    end
  end
  
  def generate_menu_group_item_content(items)
    result = ''
    items.each do |item|
      item_content = <<CONTENT
          <li><template:link href=\"#{item.link}\">#{item.title}</template:link></li>
CONTENT
      result = result + item_content
    end
    return result
  end
  
  def generate_more_item(link)
    return '' unless link
    return "<li class=\"More\"><a><template:href url=\"#{link}\"/>More...</a></li>"
  end
  
  def generate_left_bottom_logo()
    content = ''
    logo = left_bottom_logo()
    if (logo.path)
      content = <<CONTENT
      <div class="logo">
        <a href="#{logo.link}">
        	<img alt="#{logo.text}" src="#{logo.path}" width="170"/>
        </a>
      </div>
CONTENT
    end
    return content
  end
  
  def generate_releases
    if (releases.download_link.nil?)
      return ''
    end
    content = <<CONTENT
        <div class="NewsGroup">
          <h1>Latest Versions</h1>
          <table>
            <tr>
              <td><template:link href="#{releases.download_link}#stable">Stable:</template:link></td>
              <td><template:link href="#{releases.download_link}#stable">#{releases.stable_version}</template:link></td>
            </tr>
            <tr>
              <td><template:link href="#{releases.download_link}#prerelease">Prerelease:</template:link></td>
              <td><template:link href="#{releases.download_link}#prerelease">#{releases.pre_release_version}</template:link></td>
            </tr>
            <tr>
              <td><template:link href="#{releases.download_link}#snapshot">Snapshot:</template:link></td>
              <td><template:link href="#{releases.download_link}#snapshot">#{releases.snap_shot_version}</template:link></td>
            </tr>
          </table>
          <p class="NewsMore"><template:link href="#{releases.versioning_link}">About version numbers...</template:link></p>
        </div>
CONTENT
    return content
  end
  
  def generate_news
    if (news_rss.nil?)
      return ''
    end
    content = <<CONTENT
        <div class="NewsGroup">
        	<h1>Recent News</h1>
				<template:each source="#{news_rss}" select="/rss/channel/item" count="3">
                <div class="NewsItem">
                    <p class="NewsTitle"><template:include elements="./title/text()"/></p>
                    <p class="NewsDate"><template:include elements="./pubDate/text()"/></p>
                    <p class="NewsText"><template:include elements="./xhtml:div/node()"/></p>
                </div>
                </template:each>

  			<p class="NewsMore"><template:link href="#{news_rss}">News feed (RSS 2.0)</template:link></p>
				</div>
CONTENT
  end
  
  def load_template_content
    return <<CONTENT
<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">    
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:template="http://buildmaster.rubyforge.org/xtemplate/1.0">
  <head>
    <title>#{title_header}<template:include elements="/html/head/title/text()"/></title>
    <link rel="stylesheet" type="text/css"><template:href url="#{css_path}"/></link>
    <template:include elements="/html/head/*[not(title()='title')]"/>
  </head>

  <body>
		<div class="header">
			<a class="header">
			  <template:href url="#{logo.link}"/>
				#{generate_logo_text}
			</a>
		</div>

		<div class="left">
		  #{generate_menu_groups}
		  #{generate_left_bottom_logo}
		</div>

    <template:when test="index_file?">
		<div class="right">
		    #{generate_releases}
		    #{generate_news}
		</div>
		</template:when>

		<div>
		  <template:attribute name="class" eval="center_class"/>
		  <div class="content"><template:include elements="/html/body/*"/></div>
		</div>

		<div class="footer">
      <div class="bottomshadow"/>
  		<div class="poweredby">
        Powered by <a href="http://buildmaster.rubyforge.org" class="footer">BuildMaster</a>
        (version: <template:text property="buildmaster_version"/> build: <template:text property="buildmaster_buildnumber"/>)
        -
        <a class="footer"><template:href url="#{contact_admin}" />Contact Administrators</a>
        <br/>
      </div>
		</div>
    <div>
	</div>
  </body>
</html>
CONTENT
  end
end
end
