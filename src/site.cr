require "markd"
require "crustache"
require "option_parser"

# asspmuptions - index.md and template.html and github.markdown.css exist
module Site
  VERSION = "0.1.0"

	def tmp
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
	end
end

# function that works on folder
# path of folder as argument
# convert each md file to html
# each folder - call the same function
class Generator
	@file = "index.md"

	def run
		if markdown_file?
			convert_file @file
			exit
		end

		convert_folder
		exit
	end

	def markdown_file?
		if !ARGV.empty?
			@file = ARGV[0]
		end

		if File.extname(@file) == ".md"
			return true
		end

		false
	end

	def convert_file (file : String)
		puts "converting a markdown file: #{file}"
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
			dir = File.expand_path("..", dir)
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

	def convert_folder
		puts "converting a folder"
	end
end

Generator.new.run
