# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/xamarin_build/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-xamarin_build'
  spec.version       = Fastlane::XamarinBuild::VERSION
  spec.author        = %q{punksta}
  spec.email         = %q{skinnystas@gmail.com}

  spec.summary       = %q{Build xamarin android\ios projects}
  spec.homepage      = "https://github.com/punksta/fastlane-plugin-xamarin_build"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'plist'
  spec.add_dependency 'open3'
  spec.add_dependency 'openssl'


  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 1.96.0'
end
