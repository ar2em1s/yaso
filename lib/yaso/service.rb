# frozen_string_literal: true

module Yaso
  class Service
    extend Stepable

    class << self
      def call(context = {})
        context = context.is_a?(Context) ? context : Context.new(context)
        @entry ||= flow.call(self, steps)
        step = @entry
        instance = new
        step = step.call(context, instance) while step
        context
      end

      def flow(name = nil)
        @flow ||= Logic::FLOWS[:classic] if self == Yaso::Service
        return @flow || Yaso::Service.flow if name.nil?

        @flow = Logic::FLOWS[name] || raise(UnknownFlowError.new(self, name))
      end
    end
  end
end
