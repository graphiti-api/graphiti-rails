begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'yard'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'
require 'rails/version'

YARD::Rake::YardocTask.new

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--order random"
end

if Rails::VERSION::MAJOR < 7
  APP_RAKEFILE = File.expand_path("spec/rails5/dummy/Rakefile", __dir__)
else
  APP_RAKEFILE = File.expand_path("spec/rails7/dummy/Rakefile", __dir__)
end
load "rails/tasks/engine.rake"

task default: :spec
