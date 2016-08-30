# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'incoming/cli/version'

Gem::Specification.new do |spec|
  spec.name          = "incoming-cli"
  spec.version       = Incoming::Cli::VERSION
  spec.authors       = ["Calvin Yu"]
  spec.email         = ["me@sourcebender.com"]

  spec.summary       = %q{Command line tool for interacting with IncomingHQ}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "http://incominghq.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.19.1"
  spec.add_dependency "incominghq", "~> 0.1.0"
  spec.add_dependency "activesupport", ">= 4.0.0"
  spec.add_dependency "command_line_reporter", "~> 3.3.6"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
