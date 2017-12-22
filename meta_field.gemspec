$:.push File.expand_path("../lib", __FILE__)

require "meta_field/version"

Gem::Specification.new do |s|
  s.name        = "meta_field"
  s.version     = MetaField::VERSION
  s.authors     = ["Andrew Garshyn"]
  s.email       = ["andrew@ethicontrol.com"]
  s.homepage    = "https://ethicontrol.com"
  s.summary     = "Virtual columns"
  s.description = "ActiveRecord concern to store virtual columns in serialized meta column with tracking changes"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "> 4.2"

  # s.add_development_dependency "bundler", "~> 1.13"
  # s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
end
