require 'date'
require 'rake'
lib_path = File.expand_path('lib', File.dirname(__FILE__))
$:.unshift(lib_path) unless $:.include?(lib_path)
require 'gosu_android/version'
require 'gosu_android/description'

Gem::Specification.new do |s|
  s.name = %q{gosu_android}
  s.version = Gosu::VERSION
  s.date = Date.today.strftime '%Y-%m-%d'
  s.authors = ['Garoe Dorta']
  s.email = %q{neochuki@gmail.com}
  s.summary = %q{A Gosu implementation for Android.}
  s.homepage = %q{https://github.com/neochuky/gosu-android/}
  s.description = Gosu::DESCRIPTION
  s.license = 'MIT'
  s.files = FileList['[A-Z]*', 'examples/{*,.*}', 'bin/*', 'lib/**/*', 'res/*/*'].to_a
  s.executables = %w(gosu_android)
  s.default_executable = 'gosu_android'
  s.add_dependency('ruboto', '>=0.8.0')
end
