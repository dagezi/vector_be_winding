# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vector_be_winding/version'

Gem::Specification.new do |spec|
  spec.name          = "vector_be_winding"
  spec.version       = VectorBeWinding::VERSION
  spec.authors       = ["Takeshi SASAKI"]
  spec.email         = ["dagezi@gmail.com"]

  spec.summary       = %q{Let Android vector drawable follow winding-rule.}
  spec.description   = %q{Let Android vector drawable follow winding-rule.}
  spec.homepage      = "http://github.com/dagezi/vector-be-winding"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|bin|sampleApp)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "savage"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
