require "markd"
require "crustache"

module Site
  VERSION = "0.1.0"

	# asspmuptions - index.md and template.html and github.markdown.css exist

	# read md file
	# convert to markdown
	# inject into html template file
	markdown = File.read("index.md")
	html = Markd.to_html(markdown)

	navHTML = "<ul><li><a href='#/'>Home</a> &gt; <a href='#/articles/' class='active'>Articles</a></li></ul>"
	model = {"main_content" => html, "navbar" => navHTML}

	template = File.read("template.html")
	template = Crustache.parse template

	result = Crustache.render template, model

	File.write("index.html", result)
end
