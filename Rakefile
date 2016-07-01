require 'bundler/gem_tasks'


RSpec::Core::RakeTask.new

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task default: [:spec, :rubocop]
