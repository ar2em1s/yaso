module Yaso
  module Steps
    class Failure < Base
      def call(context, instance)
        instance.success = false
        @invocable.call(context, instance) ? @next_step : @failure
      end
    end
  end
end
