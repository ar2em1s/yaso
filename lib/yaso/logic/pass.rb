# frozen_string_literal: true

module Yaso
  module Logic
    class Pass < Base
      def call(context, instance)
        context.success = true
        @invokable.call(context, instance) ? @next_step : @failure
      end
    end
  end
end
