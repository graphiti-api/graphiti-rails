$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "graphiti/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "graphiti-rails"
  spec.version     = Graphiti::Rails::VERSION
  spec.authors     = ["Peter Wagenet"]
  spec.email       = ["peter.wagenet@gmail.com"]
  spec.homepage    = "https://www.graphiti.dev"
  spec.summary     = "Rails integration for Graphiti"
  # spec.description = "TODO: Description of Graphiti::Rails."
  spec.license     = "MIT"

  spec.metadata = {
    "bug_tracker_uri"   => "https://github.com/graphiti-api/graphiti-rails/issues",
    "changelog_uri"     => "https://github.com/graphiti-api/graphiti-rails/CHANGELOG.md",
    "source_code_uri"   => "https://github.com/graphiti-api/graphiti-rails"
    # "documentation_uri" => "https://www.example.info/gems/bestgemever/0.0.1",
    # "mailing_list_uri"  => "https://groups.example.com/bestgemever",
    # "wiki_uri"          => "https://example.com/user/bestgemever/wiki"
  }

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md", "CHANGELOG.md"]

  spec.add_dependency "graphiti", "~> 1.2"
  spec.add_dependency "rescue_registry", "~> 1.0"
  spec.add_dependency "railties", ">= 5.0"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rails", ">= 5.0"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "graphiti_spec_helpers", "~> 1.0"
  spec.add_development_dependency "kaminari"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "responders"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "kramdown-parser-gfm"
  spec.add_development_dependency "rouge"
end
