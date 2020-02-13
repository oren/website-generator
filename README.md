# Website Generator

Install
```
git clone git@github.com:oren/website-generator.git
shards install
crystal build src/site.cr
```

Generate html
```
./site some-markdown-file.md

#=> index.html
```

if a file named _navbar.md exist in the same folder, it will convert it's content to html and append it to the top of the html file.

