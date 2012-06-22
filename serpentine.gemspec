$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "serpentine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "serpentine"
  s.version     = Serpentine::VERSION
  s.authors     = ["Adam Hawkins"]
  s.email       = ["me@broadcastingadam.com"]
  s.homepage    = "https://github.com/twinturbo/serpentine"
  s.summary     = "Easy query parameter filters for Rails applications"
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "readme.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3"

  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
end
