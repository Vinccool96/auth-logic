# frozen_string_literal: true

require_relative "lib/auth/logic/version"

Gem::Specification.new do |spec|
  spec.name = "auth-logic"
  spec.version = Auth::Logic::VERSION
  spec.authors = ["Vincent Girard"]
  spec.email = ["vinccool96@gmail.com"]

  spec.summary = "An unobtrusive ruby authentication library based on ActiveRecord."
  spec.homepage = "https://github.com/Vinccool96/auth-logic"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Vinccool96/auth-logic"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.add_dependency "activemodel", [">= 7.1"]
  spec.add_dependency "activerecord", [">= 7.1"]
  spec.add_dependency "activesupport", [">= 7.1"]
  spec.add_dependency "request_store", ["~> 1.5", ">= 1.5.1"]

  spec.add_development_dependency "bcrypt", ["~> 3.1", ">= 3.1.19"]
  spec.add_development_dependency "byebug", ["~> 11.1", ">= 11.1.3"]
  spec.add_development_dependency "coveralls", "~> 0.8.23"
  spec.add_development_dependency "minitest-reporters", ["~> 1.6", ">= 1.6.1"]
  spec.add_development_dependency "mysql2", "~> 0.5.2"
  spec.add_development_dependency "pg", ["~> 1.5", ">= 1.5.4"]
  spec.add_development_dependency "rake", ["~> 12.3", ">= 12.3.3"]
  spec.add_development_dependency "rbs", ["~> 3.2", ">= 3.2.2"]
  spec.add_development_dependency "rubocop", ["~> 1.56", ">= 1.56.4"]
  spec.add_development_dependency "rubocop-performance", ["~> 1.19", ">= 1.19.1"]
  spec.add_development_dependency "scrypt", ["~> 3.0", ">= 3.0.7"]
  spec.add_development_dependency "simplecov", "~> 0.16.1"
  spec.add_development_dependency "simplecov-console", "~> 0.9.1"
  spec.add_development_dependency "sqlite3", ["~> 1.6", ">= 1.6.6"]
  spec.add_development_dependency "timecop", "~> 0.9.8"

  # To reduce gem size, only the minimum files are included.
  #
  # Tests are intentionally excluded. We only support our own test suite, we do
  # not have enough volunteers to support "in-situ" testing.
  spec.files = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r{^(LICENSE|lib|auth-logic.gemspec)/})
  end
  spec.test_files = [] # not packaged, see above
  spec.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
