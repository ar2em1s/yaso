# frozen_string_literal: true

require 'bundler/setup'

require_relative '../lib/yaso'

require 'benchmark/ips'
RUBY_VERSION.include?('2.5') || require('decouplio')
require 'interactor'
require 'active_interaction'
require 'trailblazer'

require_relative 'shared/yaso_service'
RUBY_VERSION.include?('2.5') || require_relative('shared/decouplio_service')
require_relative 'shared/pure_service'
require_relative 'shared/interactor_service'
require_relative 'shared/active_interaction_service'
require_relative 'shared/trailblazer_service'
require_relative 'shared/callable_step'

require_relative 'step/yaso'
RUBY_VERSION.include?('2.5') || require_relative('step/decouplio')
require_relative 'step/pure'
require_relative 'step/interactor'
require_relative 'step/active_interaction'
require_relative 'step/trailblazer'
require_relative 'step/benchmark'
