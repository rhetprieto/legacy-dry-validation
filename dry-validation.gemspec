require File.expand_path('../lib/dry/validation/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'dry-validation'
  spec.version       = Dry::Validation::VERSION
  spec.authors       = ['Andy Holland', 'Piotr Solnica']
  spec.email         = ['andyholland1991@aol.com', 'piotr.solnica@gmail.com']
  spec.summary       = 'A simple validation library'
  spec.homepage      = 'https://github.com/dry-rb/dry-validation'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0") - ['bin/console']
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = ">= 2.4.0"

  spec.add_runtime_dependency 'concurrent-ruby', '~> 1.0'
  spec.add_runtime_dependency 'dry-configurable', '0.13'
  spec.add_runtime_dependency 'dry-equalizer', '~> 0.2'
  spec.add_runtime_dependency 'dry-logic', '~> 0.5'
  spec.add_runtime_dependency 'dry-container', '0.8'
  spec.add_runtime_dependency 'dry-types', '0.14'
  spec.add_runtime_dependency 'dry-struct', '~> 0.5.0'
  spec.add_runtime_dependency 'dry-core', '0.6.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
