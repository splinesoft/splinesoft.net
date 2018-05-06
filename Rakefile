task :setup do
	sh "bundle check --path=vendor/bundle || bundle install --jobs=4 --retry=2 --path=vendor/bundle"
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
		find _site/ -iname '*.css' -exec gzip -n --best {} +
		find _site/ -iname '*.js' -exec gzip -n --best {} +
		
		for f in `find _site/ -iname '*.gz'`; do
			mv $f ${f%.gz}
		done
	}
	
	cmd_extra = "--verbose"
	
	if ENV['CIRCLECI'] == 'true'
			cmd_extra += " --access_key=$SITE_AWS_KEY --secret_key=$SITE_AWS_SECRET"
	end
		
	sh "s3cmd sync -M --progress --acl-public --recursive --no-mime-magic "+
	"--add-header='Content-Encoding:gzip' "+
	"_site/ s3://splinesoft.net/ "+
	"--exclude '*.*' "+
	"--include '*.html' --include '*.xml' "+
	"#{cmd_extra}"
	
	sh "s3cmd sync -M --progress --acl-public --recursive --no-mime-magic "+
	"--add-header='Content-Encoding:gzip' "+
	"--add-header='Cache-Control:max-age=86400' "+
	"_site/ s3://splinesoft.net/ "+
	"--exclude '*.*' "+
	"--include '*.js' --include '*.css' "+
	"#{cmd_extra}"
		
	sh "s3cmd sync --progress -M --acl-public --recursive --no-mime-magic "+
	"_site/ s3://splinesoft.net/ "+
	"--add-header='Cache-Control:max-age=86400' "+
	"--exclude '*.*' "+
	"--include '*.png' --include '*.txt' --include '*.gif' --include '*.jpg' --include '*.jpeg' "+
	"#{cmd_extra}"

end
