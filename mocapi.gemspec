# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mocapi/version'

Gem::Specification.new do |spec|
  spec.name          = "mocapi"
  spec.version       = Mocapi::VERSION
  spec.authors       = ["Mitsutaka Mimura"]
  spec.email         = ["takkanm@gmail.com"]
  spec.summary       = %q{easy mock server with yaml file}
  spec.description   = %q{easy mock server with yaml file}
  spec.homepage      = "https://github.com/takkanm/mocapi"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
