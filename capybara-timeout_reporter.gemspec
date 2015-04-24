# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "capybara-timeout_reporter"
  spec.version       = "0.0.2"
  spec.authors       = ["Vitalii Grygoruk"]
  spec.email         = ["vitaliy[dot]grigoruk[at]gmail[dot]com"]
  spec.summary       = %q{Detecting and reporting capybara sync timeouts}
  spec.description   = %q{Allows you to execute a block or raise a warning if you use a finder that reaches capybara's timeout.}
  spec.homepage      = "https://github.com/vgrigoruk/capybara-timeout_reporter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "capybara", "~> 2.0"
end
