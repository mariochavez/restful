$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "resourceful/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "resourceful"
  s.version     = Resourceful::VERSION
  s.authors     = ["Mario Alberto Chavez"]
  s.email       = ["mario.chavez@gmail.com"]
  s.homepage    = "http://blog.decisionesinteligentes.com"
  s.summary     = "Resourceful helps to keep Controllers DRY, removing repetitive code from basic REST actions."
  s.description = "Resourceful helps you to remove duplicated code from controllers were their REST actions are pretty standard and repetitive."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "minitest-rails", "~> 0.9.0"
end
