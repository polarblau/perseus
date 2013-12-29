# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'perseus/version'

Gem::Specification.new do |s|
  s.name          = "perseus"
  s.version       = Perseus::VERSION
  s.authors       = ["Florian Plank"]
  s.email         = ["florian@polarblau.com"]
  s.homepage      = "https://github.com/polarblau/perseus"
  s.summary       = "Generate styleguides based on stylesheets."
  s.description   = ""

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_dependency 'tilt'
  s.add_dependency 'sass'
  s.add_dependency 'haml'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
end
