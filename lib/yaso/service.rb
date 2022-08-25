# frozen_string_literal: true

module Yaso
  class Service
    extend Stepable

    def self.call(context = {})
      context = context.is_a?(Context) ? context : Context.new(context)
      @entry ||= Logic::Classic.call(self, steps)
      step = @entry
      instance = new
      step = step.call(context, instance) while step
      context
    end
  end
end
