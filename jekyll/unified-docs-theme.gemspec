# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "unified-docs-theme"
  spec.version       = "0.1.0"
  spec.authors       = ["Luke Bemish"]
  spec.email         = ["lukebemish@lukebemish.dev"]

  spec.summary       = "Jekyll theme with unified styling between javadoc and long-form docs."
  spec.homepage      = "https://github.com/lukebemishprojects/unified-docs-style"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
    .select { |f| f.match(%r!^(_data|_layouts|_includes|LICENSE|README|_config\.yml)!i) } +
    `find assets -type f -print0`.split("\x0") +
    `find _sass -type f -print0`.split("\x0")

  spec.add_runtime_dependency "jekyll", "~> 4.4"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.9"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.1"

  spec.add_development_dependency "bundler"

  spec.required_ruby_version = ">= 3.3.0"
  
  spec.metadata = { "github_repo" => "ssh://github.com/lukebemishprojects/unified-docs-style" }
end
