require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/reporters'
require 'simplecov'
require 'coveralls'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  command_name 'test'
  add_filter   'test'
end
