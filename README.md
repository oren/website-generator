# Website Generator
This is a static site generator

## How does it work?
It creates html file for each markdown file it finds in a given folder.
You have two ways to run it - on a .md file or on a folder. If you run it on a folder it will go to all subfoldres.

For every markdown file it finds, it will look for _navbar.md at a folder above. If it finds one, it will use it as a navigation bar for this html file.

## Install
```
git clone git@github.com:oren/website-generator.git
shards install
crystal build src/site.cr
```

## Generate html when given a markdown file
```
./site some-markdown-file.md

#=> index.html
```


