# frozen_string_literal: true

module Yaso
  module Logic
    class Pass < Base
      def call(context, instance)
        [@invocable.call(context, instance) ? @next_step : @failure, true]
      end
    end
  end
end
