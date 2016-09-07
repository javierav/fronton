require_relative 'lib/fronton/version'
require 'date'

Gem::Specification.new do |spec|
  #
  ## INFORMATION
  #
  spec.name = 'fronton'
  spec.version = Fronton.version
  spec.summary = 'A command-line tool for build frontend apps in Ruby'
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
  spec.require_paths = %w(lib)
  spec.files = `git ls-files -z -- lib bin template LICENSE README.md fronton.gemspec`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.extra_rdoc_files = %w(README.md LICENSE)
  spec.required_ruby_version = '~> 2.3'

  #
  ## DEPENDENCIES
  #
  spec.add_dependency 'thor',      '~> 0.19'
  spec.add_dependency 'rack',      '~> 2.0'
  spec.add_dependency 'sprockets', '~> 3.7'

  #
  ## DEVELOPMENT DEPENDENCIES
  #
  spec.add_development_dependency 'coveralls',          '~> 0.8'
  spec.add_development_dependency 'minitest',           '~> 5.9'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1'
  spec.add_development_dependency 'rake',               '~> 11.2'
  spec.add_development_dependency 'simplecov',          '~> 0.12'
end
