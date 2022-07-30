# frozen_string_literal: true

module Yaso
  module Logic
    class Step < Base
      def call(context, instance)
        context.success = true
        if @invokable.call(context, instance)
          @next_step
        else
          context.success = false
          @failure
        end
      end
    end
  end
end
