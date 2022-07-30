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

  spec.add_development_dependency('ffaker', '~> 2.21.0')
  spec.add_development_dependency('lefthook', '~> 1.0.5')
  spec.add_development_dependency('pry', '~> 0.14.1')
  spec.add_development_dependency('rake', '~> 13.0.6')
  spec.add_development_dependency('rspec', '~> 3.11.0')
  spec.add_development_dependency('rubocop', '< 1.29.0', '>= 1.28.2')
  spec.add_development_dependency('rubocop-ast', '< 1.18.0', '>= 1.17.0')
  spec.add_development_dependency('rubocop-performance', '< 1.14.0', '>= 1.13.3')
  spec.add_development_dependency('rubocop-rspec', '< 2.11.0', '>= 2.10.0')
  spec.add_development_dependency('simplecov', '~> 0.21.2')

  spec.metadata['rubygems_mfa_required'] = 'true'
end
