# frozen_string_literal: true

require 'simplecov'
require 'yaso'

require 'ffaker'

Dir["#{Dir.pwd}/spec/support/**/*.rb"].sort.each { |file| require file }

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.disable_monkey_patching!
  config.include ServiceClassHelpers, type: :integration

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
