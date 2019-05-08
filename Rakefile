begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'yard'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

YARD::Rake::YardocTask.new

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--order random"
end

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"

task default: :spec
