# frozen_string_literal: true

require_relative './lib/mato/version'

Gem::Specification.new do |spec|
  spec.name          = "mato"
  spec.version       = Mato::VERSION
  spec.authors       = ["FUJI Goro"]
  spec.email         = ["goro-fuj@bitjoureny.com"]

  spec.summary       = 'MArkdown TOolkit'
  spec.description   = 'An extensible markdown processing toolkit based on CommonMark'
  spec.homepage      = "https://github.com/bitjourney/mato"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3"

  spec.add_dependency "nokogiri", ">= 1.6"
  spec.add_dependency "commonmarker", ">= 0.14"
  spec.add_dependency "rouge", ">= 2.0"

  spec.add_development_dependency "bundler", ">= 1.14"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "minitest", ">= 5.0"
  spec.add_development_dependency "minitest-power_assert"
end
