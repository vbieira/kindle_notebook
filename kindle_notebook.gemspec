# frozen_string_literal: true

require_relative "lib/kindle_notebook/version"

Gem::Specification.new do |spec|
  spec.name = "kindle_notebook"
  spec.version = KindleNotebook::VERSION
  spec.authors = ["Bianca Vieira"]
  spec.email = ["vbieira@outlook.com"]

  spec.summary = "Kindle Notebook"
  spec.description = "Fetch Kindle Highlights and Notes"
  spec.homepage = "https://github.com/vbieira/kindle_notebook"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/vbieira/kindle_notebook"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "capybara"
  spec.add_dependency "capybara-sessionkeeper"
  spec.add_dependency "dotenv"
  spec.add_dependency "pry"
  spec.add_dependency "selenium-webdriver"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
