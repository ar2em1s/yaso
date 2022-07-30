# frozen_string_literal: true

module Yaso
  module Logic
    class Base
      attr_reader :name, :on_success, :on_failure

      def initialize(name:, invokable:, **options)
        @name = name
        @invokable = invokable
        @fast = options[:fast]
        @on_success = options[:on_success]
        @on_failure = options[:on_failure]
      end

      def call(_, _)
        raise NotImplementedError
      end

      def add_next_step(step)
        @next_step = step unless @fast == true || @fast == :success
      end

      def add_failure(failure)
        @failure = failure unless @fast == true || @fast == :failure
      end
    end
  end
end
