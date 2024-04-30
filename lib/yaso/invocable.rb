# frozen_string_literal: true

module Yaso
  class Invocable
    METHOD = :method
    CALLABLE = :callable
    YASO = :yaso

    class << self
      def call(object, options: {}, with_block: false, **)
        type = object_type(object)
        invocable = case type
                    when YASO then proc { |context| object.call(context).success? }
                    when CALLABLE then callable_invocable(object, options, with_block: with_block)
                    else method_invocable(object, with_block: with_block)
                    end
        [type, invocable]
      end

      private

      def object_type(object)
        return Invocable::METHOD unless object.is_a?(Class)

        object < ::Yaso::Service ? Invocable::YASO : Invocable::CALLABLE
      end

      def callable_invocable(object, options, with_block:)
        return proc { |context, &block| object.call(context, **options, &block) } if with_block

        proc { |context| object.call(context, **options) }
      end

      def method_invocable(object, with_block:)
        with_block ? method_invocable_with_block(object) : method_invocable_without_block(object)
      end

      def method_invocable_with_block(object)
        instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          proc { |context, instance, &block|               # proc { |context, instance, &block|
            instance.#{object}(context, **context, &block) #   instance.<method_name>(context, **context, &block)
          }                                                # }
        RUBY
      end

      def method_invocable_without_block(object)
        instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          proc { |context, instance|               # proc { |context, instance|
            instance.#{object}(context, **context) #   instance.<method_name>(context, **context)
          }                                        # }
        RUBY
      end
    end
  end
end
