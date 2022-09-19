# frozen_string_literal: true

module Yaso
  module Logic
    class Failure < Base
      def call(context, instance)
        [@invocable.call(context, instance) ? @next_step : @failure, false]
      end
    end
  end
end
