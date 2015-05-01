task :setup do
	sh "bundle check --path=vendor/bundle || bundle install --jobs=4 --retry=2 --path=vendor/bundle"
	sh "npm list write-good || npm install -g write-good"
end

task :serve do
	sh "bundle exec jekyll serve --watch --config _config.yml"
end

task :build do
		sh "bundle exec jekyll build --config _config.yml"
end

task :lint do
		sh "bundle exec htmlproof --check-favicon --checks-to-ignore HtmlCheck _site"
		puts `write-good *.html`
end

task :publish do	
	system %{
				
		find _site/ -iname '*.html' -exec gzip -n --best {} +
		find _site/ -iname '*.xml' -exec gzip -n --best {} +
		
		for f in `find _site/ -iname '*.gz'`; do
			mv $f ${f%.gz}
		done
	}
	
	cmd_extra = "--verbose"
	
	if ENV['CIRCLECI'] == 'true'
			cmd_extra += " --access_key=$SITE_AWS_KEY --secret_key=$SITE_AWS_SECRET"
	end
	
	# Sync GZip'd HTML and XML
	
	sh "s3cmd sync -M --progress --acl-public --recursive --no-mime-magic "+
	"--add-header='Content-Encoding:gzip' "+
	"_site/ s3://splinesoft.net/ "+
	"--exclude '*.*' "+
	"--include '*.html' --include '*.xml' "+
	"#{cmd_extra}"
	
	# Sync all remaining files
	
	sh "s3cmd sync --progress -M --acl-public --recursive "+
	"_site/ s3://splinesoft.net/ "+
	"--exclude '*.*' "+
	"--include '*.png' --include '*.css' --include '*.js' --include '*.txt' --include '*.gif' --include '*.jpg' --include '*.jpeg' "+
	"#{cmd_extra}"

end
