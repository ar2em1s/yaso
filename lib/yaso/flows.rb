require_relative "flows/classic"
require_relative "flows/rollback"

module Yaso
  module Flows
    MAP = {
      classic: Classic,
      rollback: Rollback
    }
  end
end
