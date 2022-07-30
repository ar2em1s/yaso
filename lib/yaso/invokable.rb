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
                    when YASO then ->(context, _) { object.call(context.clone).success? }
                    when CALLABLE then ->(context, _, &block) { object.call(context, **options, &block) }
                    else ->(context, instance, &block) { instance.send(object, context, **context.to_h!, &block) }
                    end
        [type, invokable]
      end

      private

      def object_type(object)
        return Invokable::METHOD unless object.is_a?(Class)

        object < ::Yaso::Service ? Invokable::YASO : Invokable::CALLABLE
      end
    end
  end
end
