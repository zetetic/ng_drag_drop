task :default => [:karma_test_prepare]

task :karma_test_prepare do
  sh 'mkdir -p vendor/assets/javascripts'
  Dir.chdir 'vendor/assets/javascripts'
  sh 'ln -s $(bundle show angularjs-rails)/vendor/assets/javascripts angular'
  sh 'ln -s $(bundle show raphael-rails)/vendor/assets/javascripts raphael'
end

task :watch_page do
  sh 'mkdir -p tmp'
  sh 'http-server -p 3502 . &'
  sh 'coffee --watch --compile --output tmp/ lib/assets/javascripts/ &'
  sh 'open test/test.html'
end
