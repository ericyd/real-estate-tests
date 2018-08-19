lib = File.expand_path('./lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:features)
RuboCop::RakeTask.new

task default: [:test]

task test: %i[spec features rubocop]

task lint: [:rubocop]
