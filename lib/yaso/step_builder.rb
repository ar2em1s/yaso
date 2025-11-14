module Yaso
  class StepBuilder
    CATEGORIES = {
      step: Steps::Step,
      pass: Steps::Pass,
      failure: Steps::Failure,
      wrap: Steps::Wrap,
      switch: Steps::Switch
    }.freeze

    def initialize(klass)
      @klass = klass
    end

    def call(object:, category:, block:, **opts)
      logic_class = CATEGORIES[category]
      invocable_type, invocable = Invocable.call(object, with_block: logic_class == Steps::Wrap, **opts)
      if invocable_type == Invocable::METHOD
        opts[:name] = if logic_class == Steps::Switch
          build_switch(object, **opts, &block)
        else
          build_method(object, &block)
        end
      end
      opts[:wrapper] = build_wrapper(&block) if logic_class == Steps::Wrap
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
      wrapper_class.define_singleton_method(:call) do |context, instance|
        @entry ||= service_class.flow.call(service_class, steps)
        step = @entry
        step = step.call(context, instance) while step
        instance
      end
    end
  end
end
