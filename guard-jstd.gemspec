# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/jstd/version"

Gem::Specification.new do |s|
  s.name        = "guard-jstd"
  s.version     = Guard::JstdVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["aRailsDemo"]
  s.email       = ["arailsdemo@gmail.com"]
  s.homepage    = "https://github.com/arailsdemo/guard-jstd"
  s.summary     = %q{A Guard for JsTestDriver}
  s.description = %q{This will watch for changes in your JavaScript project and automatically run JsTestDriver}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("guard", ">= 0.3.0")
  s.add_development_dependency("rspec", "~> 2.4.0")
end
