module Yaso
  module Steps
    class Pass < Base
      def call(context, instance)
        instance.success = true
        @invocable.call(context, instance) ? @next_step : @failure
      end
    end
  end
end
