module Yaso
  module Steps
    class Switch < Base
      def call(context, instance)
        instance.success = true
        switch_case = @invocable.call(context, instance) || raise(UnhandledSwitchCaseError, instance.class)
        if Invocable.call(switch_case).last.call(context, instance)
          @next_step
        else
          instance.success = false
          @failure
        end
      end
    end
  end
end
