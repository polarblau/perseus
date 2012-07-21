# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'perseus/version'

Gem::Specification.new do |s|
  s.name          = "perseus"
  s.version       = Perseus::VERSION
  s.authors       = ["Polarblau"]
  s.email         = ["polarblau@gmail.com"]
  s.homepage      = "https://github.com/polarblau/perseus"
  s.summary       = "TODO: summary"
  s.description   = "TODO: description"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_dependency 'sass'
  s.add_dependency 'racc'
  s.add_dependency 'rexical'
  s.add_dependency 'csspool'
end
