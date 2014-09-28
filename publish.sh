#!/bin/bash

SITE="s3://splinesoft.net/"

bundle install

bundle exec jekyll build --config _config.yml
bundle exec htmlproof --verbose --favicon ./_site

find _site/ -iname '*.html' -exec gzip -n --best {} +
find _site/ -iname '*.xml' -exec gzip -n --best {} +

for f in `find _site/ -iname '*.gz'`; do
	mv $f ${f%.gz}
done

# Sync GZip'd HTML and XML

s3cmd sync --progress -M --acl-public \
--add-header 'Content-Encoding:gzip' \
_site/ $SITE \
--exclude '*.*' \
--include '*.html' --include '*.xml' \
--verbose 

# Sync all remaining files

s3cmd sync --progress -M --acl-public \
_site/ $SITE \
--exclude '*.*' \
--include '*.png' --include '*.css' --include '*.js' --include '*.txt' \
--verbose 
