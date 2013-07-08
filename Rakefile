begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Resourceful'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Bundler::GemHelper.install_tasks

require 'rake/testtask'

desc 'Run rubocop checks'
task :rubocop do
    sh 'rubocop lib test'
end

desc 'Run flay checks'
task :flay do
    sh 'find lib -name \*.rb | xargs flog'
end

desc 'Run flog checks'
task :flog do
    sh 'flay lib/*.rb'
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end


task default: :test
