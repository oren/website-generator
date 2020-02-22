require "markd"
require "crustache"

TEMPLATE = {{ read_file("template.html") }}

class Generator
	@file = "index.md"

	def run
		if markdown_file?
			convert_file @file
			exit
		end

		convert_folder @file
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
		puts "converting the markdown file: #{file}"
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

		template = Crustache.parse TEMPLATE

		# inject main content and navbar
		result = Crustache.render template, model

		File.write(outputPath, result)
	end

	def convert_folder (folder : String)
		puts "converting the folder #{folder}"
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
end

Generator.new.run
