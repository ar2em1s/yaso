# frozen_string_literal: true

class CallableStep
  def self.call(ctx, key:, value:, **)
    ctx[key] = value
  end
end
