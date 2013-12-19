$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "restful/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "restful_controller"
  s.version     = Restful::VERSION
  s.authors     = ["Mario Alberto Chavez"]
  s.email       = ["mario.chavez@gmail.com"]
  s.homepage    = "http://blog.decisionesinteligentes.com"
  s.summary     = "Restful helps to keep Controllers DRY, removing repetitive code from basic REST actions."
  s.description = "Restful helps you to remove duplicated code from controllers were their REST actions are pretty standard and repetitive."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "flog"
  s.add_development_dependency "flay"
  s.add_development_dependency "minitest-rails", "~> 0.9.0"
end
