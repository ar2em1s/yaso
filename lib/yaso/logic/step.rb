# frozen_string_literal: true

module Yaso
  module Logic
    class Step < Base
      def call(context, instance)
        @invocable.call(context, instance) ? [@next_step, true] : [@failure, false]
      end
    end
  end
end
