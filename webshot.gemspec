# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webshot/version'

Gem::Specification.new do |spec|
  spec.name          = "webshot"
  spec.version       = Webshot::VERSION
  spec.authors       = ["Vitalie Cherpec"]
  spec.email         = ["vitalie@penguin.ro"]
  spec.description   = %q{Captures a web page as a screenshot using Poltergeist, Capybara and PhantomJS}
  spec.summary       = %q{Captures a web page as a screenshot}
  spec.homepage      = "https://github.com/vitalie/webshot"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "gem-release"

  spec.add_dependency "activesupport"
  spec.add_dependency "poltergeist", "~> 1.12.0"
  spec.add_dependency "faye-websocket", "~> 0.7.3"
  spec.add_dependency "mini_magick", "~> 4.3.3"
end
