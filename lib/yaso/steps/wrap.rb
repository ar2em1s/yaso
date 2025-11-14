module Yaso
  module Steps
    class Wrap < Base
      def initialize(wrapper:, **options)
        super(**options)
        @wrapper = wrapper
      end

      def call(context, instance)
        instance.success = true
        result = @invocable.call(context, instance) { @wrapper.call(context, instance).success? }
        if result
          @next_step
        else
          instance.success = false
          @failure
        end
      end
    end
  end
end
