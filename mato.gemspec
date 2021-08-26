# frozen_string_literal: true

require_relative './lib/mato/version'

Gem::Specification.new do |spec|
  spec.name          = "mato"
  spec.version       = Mato::VERSION
  spec.authors       = ["FUJI Goro"]
  spec.email         = ["goro-fuj@bitjoureny.com"]

  spec.summary       = 'MArkdown TOolkit'
  spec.description   = 'A pipeline-based markdown toolkit with CommonMark(er)'
  spec.homepage      = "https://github.com/bitjourney/mato"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = 'https://github.com/bitjourney/mato/blob/master/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/bitjourney/mato/issues'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(?:test|spec|features|example)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.7"

  spec.add_runtime_dependency "commonmarker", ">= 0.18.1"
  spec.add_runtime_dependency "nokogiri", ">= 1.12"
  spec.add_runtime_dependency "rouge", ">= 3.0.0"
end
