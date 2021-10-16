# frozen_string_literal: true

require_relative "lib/wm_indx/version"

Gem::Specification.new do |spec|
  spec.name          = "wm_indx"
  spec.version       = WmIndx::VERSION
  spec.authors       = ["Alexey Zverev"]
  spec.email         = ["30625576+azrocketa@users.noreply.github.com"]

  spec.summary       = "Api for https://indx.money"
  spec.description   = "http://wiki.web.money/projects/webmoney/wiki/INDX_API"
  spec.homepage      = "https://github.com/azrocketa/wm-indx"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/azrocketa/wm-indx"
  spec.metadata["changelog_uri"] = "https://github.com/azrocketa/wm-indx/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "digest", "~> 3.0"
  spec.add_dependency "json", "~> 2.5"
  spec.add_dependency "uri", "~> 0.10"
end
