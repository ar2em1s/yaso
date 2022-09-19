# frozen_string_literal: true

module Yaso
  module Logic
    class Switch < Base
      def call(context, instance)
        switch_case = @invocable.call(context, instance) || raise(UnhandledSwitchCaseError, instance.class)
        Invocable.call(switch_case).last.call(context, instance) ? [@next_step, true] : [@failure, false]
      end
    end
  end
end
