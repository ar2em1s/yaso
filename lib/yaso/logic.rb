# frozen_string_literal: true

require_relative 'logic/base'
require_relative 'logic/step'
require_relative 'logic/pass'
require_relative 'logic/failure'
require_relative 'logic/wrap'
require_relative 'logic/switch'
require_relative 'logic/step_builder'
require_relative 'logic/classic'
require_relative 'logic/rollback'

module Yaso
  module Logic
    FLOWS = {
      classic: Logic::Classic,
      rollback: Logic::Rollback
    }.freeze
  end
end
