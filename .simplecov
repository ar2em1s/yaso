# frozen_string_literal: true

SimpleCov.start do
  enable_coverage :branch

  add_filter 'spec'
  add_filter 'benchmark'
end
