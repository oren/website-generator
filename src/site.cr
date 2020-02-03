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
	if !ARGV.empty?
		file = ARGV[0]
	end

	dir = ""
	begin
		dir = File.dirname(file)
	rescue ex
		puts ex.message
		exit
	end

  outputPath = "#{dir}/index.html"

	markdown = ""
	begin
		markdown = File.read(file)
	rescue ex
		puts ex.message
		exit
	end

	html = Markd.to_html(markdown)
	navHTML = ""

	begin
		navMarkdown = File.read("#{dir}/_navbar.md")
		navHTML = Markd.to_html(navMarkdown)
	rescue ex
		# do nothing
	end

	model = {"main_content" => html, "navbar" => navHTML}

	template = File.read("template.html")
	template = Crustache.parse template

	# inject main content and navbar
	result = Crustache.render template, model

	File.write(outputPath, result)
end
