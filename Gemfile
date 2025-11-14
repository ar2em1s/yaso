source "https://rubygems.org"

gemspec

version_parts = RUBY_VERSION.split(".")
minor_version_path = version_parts[..1].join("_")

if File.exist?("gemfiles/ruby_#{minor_version_path}/Gemfile")
  eval_gemfile "gemfiles/ruby_#{minor_version_path}/Gemfile"
else
  eval_gemfile "gemfiles/ruby_#{version_parts[0]}/Gemfile"
end

group :development, :test do
  gem "lefthook", "~> 2.0.4"
  gem "pry", "~> 0.15.2"
  gem "rake", "~> 13.3.1"
end

group :test do
  gem "rspec", "~> 3.13.2"
  gem "simplecov", "~> 0.22.0"
end
