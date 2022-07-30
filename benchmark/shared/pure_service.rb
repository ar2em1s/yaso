# frozen_string_literal: true

class PureService
  attr_reader :ctx

  def self.call(**ctx)
    new(ctx).call
  end

  def initialize(ctx)
    @ctx = ctx
  end
end
