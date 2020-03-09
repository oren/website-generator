# Program that convenrts markdown files into html

# Usage:
# 1. Convert a single markdown file: ./site path/to/markdownfile.md
# 2. Convert all markdown files inside a folder: ./site path/to/folder

require "option_parser"
require "markd"
require "crustache"

TEMPLATE = {{ read_file("template.html") }}

numbers = false

option_parser = OptionParser.parse do |parser|
	parser.banner = "Program that convenrts markdown files into html.
Usage: site [--numbers] [Folder|File]"

	parser.on "-v", "--version", "Show version" do
		puts "version 1.0"
		exit
	end
	parser.on "-h", "--help", "Show help" do
		puts parser
		exit
	end
	parser.on "-n", "--numbers", "Add numbers to h2" do
		numbers = true
	end
end

Generator.new.run(numbers)

class Generator
	def run (numbers : Bool)
		if ARGV.empty?
			convert_folder "."
			exit
		end

		isDir = File.directory?(ARGV[0])

		if isDir
			convert_folder ARGV[0]
			exit
		end

		if markdown_file?
			if numbers
				add_numbers ARGV[0]
			end

			convert_file ARGV[0]
			exit
		end

		abort "Please provide a markdown file with an .md extention"
	end

	private def markdown_file?
		if File.extname(ARGV[0]) == ".md"
			return true
		end

		false
	end

	private def convert_file (file : String)
		puts "convert #{file}"
		dir = ""
		begin
			dir = File.dirname(file)
		rescue ex
			puts "Can't open #{file}"
			# puts ex.message
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

		template = Crustache.parse TEMPLATE

		# inject main content and navbar
		result = Crustache.render template, model

		File.write(outputPath, result)
	end

	private def convert_folder (folder : String)
		# if .md file exist - convert it
		if(File.file?(folder + "/README.md"))
			 convert_file(folder + "/README.md")
		end

		# for each folder - call myself
		dir = Dir.open(folder)
		dir.each_child { |x|
			path = File.expand_path(x, folder)
			isDirectory = File.directory?(path)
			if isDirectory
				convert_folder path
			end
		}
	end

	# Add numbers to h2
	# ## Leadership => ## 1. Leadership
	# If number exist - re-number it
	private def add_numbers (path_to_markdown : String)
		output = ""
		text = File.read(path_to_markdown)

		number = 1
		text.each_line do |line|
			match = line.match(/^## \d+./)
			if match
				line_with_number = line.gsub(/^## \d+./, "## #{number}.")
				number += 1
			else
				match = line.match(/^## /)
				if match
					line_with_number = line.gsub(/^## /, "## #{number}. ")
					number += 1
				else
					line_with_number = line
				end
			end

			output += line_with_number + "\n"
		end

		File.write(path_to_markdown, output)
	end
end

