# coding: utf-8
lib = File.expand_path("./lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "rspec/core/rake_task"
require "cucumber/rake/task"

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:features)

task default: [:test]

task test: [:spec, :features]