# encoding: UTF-8
require "bundler/gem_tasks"
require "rake/testtask"
require "rdoc/task"

desc "Default: run tests."
task :default => :test


desc "Run webshot unit tests."
Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = Dir[ "test/*_test.rb" ]
  t.verbose = true
end
