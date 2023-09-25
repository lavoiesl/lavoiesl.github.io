require 'rexml/document'
require 'time'

include REXML
xmlfile = File.new("./blog-09-23-2023.xml")
xmldoc = Document.new(xmlfile)

# Now get the root element
root = xmldoc.root

# Iterate over each blog post
xmldoc.elements.each('/feed/entry[category[@term="http://schemas.google.com/blogger/2008/kind#post"] and link[@rel="alternate" and @type="text/html"]]') do |entry|
  title = entry.elements['title'].text
  tags = entry.get_elements('category[@scheme="http://www.blogger.com/atom/ns#"]').map { |e| e.attributes['term'] }
  link = entry.elements['link[@rel="alternate" and @type="text/html"]'].attributes['href']
  published = Time.parse(entry.elements['published'].text)
  content = entry.elements['content'].text

  filename = published.strftime("%Y-%m-%d-") + link.split('/').last

  File.open("_posts/" + filename, 'w') do |f|
    f.puts "---"
    f.puts "layout: post"
    f.puts "title: #{title.inspect}"
    f.puts "tags: #{tags.inspect}"
    f.puts "date: #{published.strftime("%Y-%m-%d %H:%M:%S %z")}"
    f.puts "---"
    f.puts
    f.puts content
  end
end
