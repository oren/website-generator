# Website Generator
This is a static site generator. It creates html files based on markdown.

## How does it work?
It creates html file for each markdown file it finds in a given folder.
You have two ways to run it - on a .md file or on a folder. If you run it on a folder it will go to all subfoldres.

For every markdown file it finds, it will look for _navbar.md at a folder above. If it finds one, it will use it as a navigation bar for this html file.

## Usage
Create html files from all markdown files in a given folder:
```
./site some-folder
```

Create an html file of a specific markdown file:
```
./site some-markdown-file.md
```

## Example
Let's say you have the following folder structure:
```
website/
├── articles
│   └── README.md
├── cookbook
│   └── README.md
├── README.md
└── talks
    └── README.md
```

Running `./site website` will output the following:
```
converting the folder website
converting the markdown file: website/README.md
converting the folder website/talks
converting the markdown file: website/talks/README.md
converting the folder website/cookbook
converting the markdown file: website/cookbook/README.md
converting the folder website/articles
converting the markdown file: website/articles/README.md
```

## Install
```
git clone git@github.com:oren/website-generator.git
shards install
crystal build src/site.cr
```
