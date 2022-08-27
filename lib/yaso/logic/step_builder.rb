# frozen_string_literal: true

module Yaso
  module Logic
    class StepBuilder
      CATEGORIES = {
        step: Step,
        pass: Pass,
        failure: Failure,
        wrap: Wrap,
        switch: Switch
      }.freeze

      def initialize(klass)
        @klass = klass
      end

      def call(object:, category:, block:, **opts)
        invocable_type, invocable = Invocable.call(object, **opts)
        logic_class = CATEGORIES[category]
        if invocable_type == Invocable::METHOD
          opts[:name] = logic_class == Switch ? build_switch(object, **opts, &block) : build_method(object, &block)
        end
        opts[:wrapper] = build_wrapper(&block) if logic_class == Wrap
        logic_class.new(invocable: invocable, **opts)
      end

      private

      def build_switch(object, options:, **, &block)
        if block.nil?
          key = options[:key]
          cases = options[:cases]
          block = ->(ctx, **) { cases[ctx[key]] }
        end
        build_method(object, &block)
      end

      def build_method(name, &block)
        return name if @klass.method_defined?(name)
        raise StepIsNotImplementedError.new(@klass, name) unless block

        @klass.define_method(name, &block)
      end

      def build_wrapper(&block)
        wrapper_class = Class.new { extend Stepable }
        build_wrapper_methods(wrapper_class, @klass)
        wrapper_class.instance_exec(&block)
        wrapper_class
      end

      def build_wrapper_methods(wrapper_class, service_class)
        wrapper_class.define_singleton_method(:flow) do
          service_class.flow
        end
        wrapper_class.define_singleton_method(:call) do |context, instance|
          @entry ||= flow.call(service_class, steps)
          step = @entry
          step = step.call(context, instance) while step
          context
        end
      end
    end
  end
end
