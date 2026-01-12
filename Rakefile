require "bundler/gem_tasks"
require "rake/testtask"

# Tests without Pay gem (ActiveSupport only, no Rails)
Rake::TestTask.new("test:standalone") do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/standalone/**/*_test.rb"]
  t.warning = false
end

# Tests with Pay gem integration
Rake::TestTask.new("test:pay") do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"].exclude("test/standalone/**/*_test.rb")
  t.warning = false
end

desc "Run all tests (Standalone and Pay)"
task test: ["test:standalone", "test:pay"]

task default: :test
