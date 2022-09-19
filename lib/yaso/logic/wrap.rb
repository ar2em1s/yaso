# frozen_string_literal: true

module Yaso
  module Logic
    class Wrap < Base
      def initialize(wrapper:, **options)
        super(**options)
        @wrapper = wrapper
      end

      def call(context, instance)
        result = @invocable.call(context, instance) { @wrapper.call(context, instance).success? }
        result ? [@next_step, true] : [@failure, false]
      end
    end
  end
end
