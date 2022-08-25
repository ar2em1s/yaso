# frozen_string_literal: true

module Yaso
  class Invokable
    METHOD = :method
    CALLABLE = :callable
    YASO = :yaso

    class << self
      def call(object, options: {}, **)
        type = object_type(object)
        invokable = case type
                    when YASO then proc { |context, _| object.call(context.clone).success? }
                    when CALLABLE then proc { |context, _, &block| object.call(context, **options, &block) }
                    else method_invokable(object)
                    end
        [type, invokable]
      end

      private

      def object_type(object)
        return Invokable::METHOD unless object.is_a?(Class)

        object < ::Yaso::Service ? Invokable::YASO : Invokable::CALLABLE
      end

      def method_invokable(object)
        instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          proc { |context, instance, &block|                    # proc { |context, instance, &block|
            instance.#{object}(context, **context.data, &block) #   instance.<method_name>(context, **context.data, &block)
          }                                                     # }
        RUBY
      end
    end
  end
end
