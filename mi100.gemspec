# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mi100/version'

Gem::Specification.new do |spec|
  spec.name          = "mi100"
  spec.version       = Mi100::VERSION
  spec.authors       = ["Masami Yamakawa"]
  spec.email         = ["silkycove@gmail.com"]
  spec.description   = %q{A ruby gem for controlling MI100 of monoxit through bluetooth virtual serial port.}
  spec.summary       = %q{A ruby gem for controlling MI100}
  spec.homepage      = "https://github.com/monoxit/mi100"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  
  spec.add_dependency  "rubyserial"
end
