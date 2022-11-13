task :setup do
    sh "bundle config set --local path 'vendor/bundle'"
    sh "bundle check || bundle install --jobs=4 --retry=2"
end

task :serve do
    sh "bundle exec jekyll serve --watch --config _config.yml"
end

task :build do
    sh "bundle exec jekyll build --config _config.yml"
end

task :lint do
    sh "bundle exec htmlproofer --only-4xx --no-enforce-https _site"
end
