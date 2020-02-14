# Website Generator
This is a static site generator

## How does it work?
It creates html file for each markdown file it finds in a given folder. If a file named _navbar.md exist in the same folder, it will convert it's content to html and append it to the top of the html file.
You have two ways to run it - on a .md file or on a folder. If you run it on a folder it will go to all subfoldres.


Install
```
git clone git@github.com:oren/website-generator.git
shards install
crystal build src/site.cr
```

Generate html when given a markdown file
```
./site some-markdown-file.md

#=> index.html
```


