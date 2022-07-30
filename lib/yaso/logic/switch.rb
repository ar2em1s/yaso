# frozen_string_literal: true

module Yaso
  module Logic
    class Switch < Base
      def call(context, instance)
        context.success = true
        switch_case = @invokable.call(context, instance) || raise(UnhandledSwitchCaseError, instance.class)

        if Invokable.call(switch_case).last.call(context, instance)
          @next_step
        else
          context.success = false
          @failure
        end
      end
    end
  end
end
