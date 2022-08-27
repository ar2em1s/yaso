# frozen_string_literal: true

module Yaso
  module Logic
    class Step < Base
      def call(context, instance)
        context.success = true
        if @invocable.call(context, instance)
          @next_step
        else
          context.success = false
          @failure
        end
      end
    end
  end
end
