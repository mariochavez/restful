$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "restful/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "restful_controller"
  s.version     = Restful::VERSION
  s.authors     = ["Mario Alberto Chávez"]
  s.email       = ["mario.chavez@gmail.com"]
  s.homepage    = "https://mariochavez.io"
  s.summary     = "Restful helps to keep Controllers DRY, removing repetitive code from basic REST actions."
  s.description = "Restful helps you to remove duplicated code from controllers were their REST actions are pretty standard and repetitive."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 6.0.0.rc2"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "standard"
end
