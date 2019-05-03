$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "graphiti/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "graphiti-rails"
  spec.version     = Graphiti::Rails::VERSION
  spec.authors     = ["Peter Wagenet"]
  spec.email       = ["peter.wagenet@gmail.com"]
  spec.homepage    = "" #"TODO"
  spec.summary     = "" #"TODO: Summary of Graphiti::Rails."
  spec.description = "" #"TODO: Description of Graphiti::Rails."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "graphiti", "~> 1.0.2"
  spec.add_dependency "rails", ">= 5.0"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "graphiti_spec_helpers", "~> 1.0"
  spec.add_development_dependency "kaminari"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "responders"
end
