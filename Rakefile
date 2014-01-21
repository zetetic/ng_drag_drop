task :default => [:karma_test_prepare]

task :karma_test_prepare do
  sh 'mkdir -p vendor/assets/javascripts'
  Dir.chdir 'vendor/assets/javascripts'
  sh 'ln -s $(bundle show angularjs-rails)/vendor/assets/javascripts angular'
end
