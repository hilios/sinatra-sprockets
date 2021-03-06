$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sinatra/sprockets/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sinatra-sprockets-chain"
  s.version     = Sinatra::Sprockets::VERSION
  s.authors     = ["Edson Hilios"]
  s.email       = ["edson.hilios@gmail.com"]
  s.homepage    = "https://github.com/hilios/sinatra-sprockets"
  s.summary     = "Plug and play extension for sinatra that mimic rails assets pipeline through sprockets"
  s.description = "Plug and play extension for sinatra that mimic rails assets pipeline through sprockets"

  s.files         = Dir["CHANGELOG.md", "MIT-LICENSE", "README.md", "lib/**/*"]
  s.test_files    = Dir["test/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "sprockets", "~> 2.10.0"
  s.add_dependency "sprockets-helpers", "~> 1.0.1"
  
  s.add_development_dependency "sinatra"
  s.add_development_dependency "rake"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "minitest"
  s.add_development_dependency "minitest-colorize"
end