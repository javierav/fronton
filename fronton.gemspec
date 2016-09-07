require_relative 'lib/fronton/version'
require 'date'

Gem::Specification.new do |spec|
  #
  ## INFORMATION
  #
  spec.name = 'fronton'
  spec.version = Fronton.version
  spec.summary = ''
  spec.description = nil
  spec.author = 'Javier Aranda'
  spec.email = 'javier.aranda.varo@gmail.com'
  spec.license = 'MIT'
  spec.date = Date.today.strftime('%Y-%m-%d')
  spec.homepage = 'https://github.com/javierav/fronton'

  #
  ## GEM
  #
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = %w(lib)
  spec.files = `git ls-files -z -- lib bin template LICENSE README.md fronton.gemspec`.split("\x0")
  spec.extra_rdoc_files = %w(README.md LICENSE)
  spec.required_ruby_version = '~> 2.3'

  #
  ## DEPENDENCIES
  #
  spec.add_dependency 'thor',      '~> 0.19', '>= 0.19.1'
  spec.add_dependency 'rack',      '~> 2.0', '>= 2.0.1'
  spec.add_dependency 'sprockets', '~> 3.7'
end
