# frozen_string_literal: true

module Yaso
  module Logic
    class Failure < Base
      def call(context, instance)
        context.success = false
        @invokable.call(context, instance) ? @next_step : @failure
      end
    end
  end
end
