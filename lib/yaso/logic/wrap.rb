# frozen_string_literal: true

module Yaso
  module Logic
    class Wrap < Base
      def initialize(wrapper:, **options)
        super(**options)
        @wrapper = wrapper
      end

      def call(context, instance)
        context.success = true
        if @invokable.call(context, instance) { @wrapper.call(context, instance).success? }
          @next_step
        else
          context.success = false
          @failure
        end
      end
    end
  end
end
