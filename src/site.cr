require "markd"
require "crustache"
require "option_parser"

# asspmuptions - index.md and template.html and github.markdown.css exist
module Site
  VERSION = "0.1.0"

	option_parser = OptionParser.parse do |parser|
		parser.banner = "I am your coach!"

		parser.on "-v", "--version", "Show version" do
			puts "version 1.0"
			exit
		end
		parser.on "-h", "--help", "Show help" do
			puts parser
			exit
		end
	end


	file = "index.md"
	if ARGV[0]
		file = ARGV[0]
	end

	#outputPath = "#{File.basename(file, File.extname(file))}.html"
	dir = File.dirname(file)
  outputPath = "#{dir}/index.html"

	# read md file
	# convert to markdown
	# inject into html template file
	markdown = File.read(file)
	html = Markd.to_html(markdown)

	navHTML = "<ul><li><a href='#/'>Home</a> &gt; <a href='#/articles/' class='active'>Articles</a></li></ul>"
	model = {"main_content" => html, "navbar" => navHTML}

	template = File.read("template.html")
	template = Crustache.parse template

	result = Crustache.render template, model
	puts outputPath

	File.write(outputPath, result)
end
