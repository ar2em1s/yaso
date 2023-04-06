# frozen_string_literal: true

require 'bundler/setup'

require 'benchmark/ips'
require 'decouplio'
require 'interactor'
require 'active_interaction'
require 'trailblazer'
require 'simple_command'
require 'yaso'
require 'dry/container'
require 'dry/transaction'
require 'dry/transaction/operation'

require_relative 'shared/yaso_service'
require_relative 'shared/decouplio_service'
require_relative 'shared/pure_service'
require_relative 'shared/simple_command_service'
require_relative 'shared/interactor_service'
require_relative 'shared/active_interaction_service'
require_relative 'shared/trailblazer_service'
require_relative 'shared/callable_step'

require_relative 'step/yaso'
require_relative 'step/decouplio'
require_relative 'step/pure'
require_relative 'step/simple_command'
require_relative 'step/interactor'
require_relative 'step/active_interaction'
require_relative 'step/trailblazer'
require_relative 'step/dry_transaction'

require_relative 'step/benchmark'
