# frozen_string_literal: true

require_relative 'lib/yaso/version'

Gem::Specification.new do |spec|
  spec.name = 'yaso'
  spec.version = Yaso::VERSION
  spec.authors = ['Artem Shevchenko']
  spec.email = ['artemsheva0510@gmail.com']

  spec.summary = 'Yet Another Service Object'
  spec.description = 'One more Service Object pattern implementation'
  spec.homepage = 'https://github.com/Ar2emis/yaso'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.5'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Ar2emis/yaso'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.require_paths = ['lib']

  spec.metadata['rubygems_mfa_required'] = 'true'
end
