# frozen_string_literal: true

class SimpleCommandService
  prepend SimpleCommand

  attr_reader :ctx

  def initialize(**ctx)
    @ctx = ctx
  end
end
