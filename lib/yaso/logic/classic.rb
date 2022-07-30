# frozen_string_literal: true

module Yaso
  module Logic
    class Classic
      def self.call(klass, steps)
        new(klass, steps).call
      end

      def initialize(klass, steps)
        @klass = klass
        @steps = steps
        @step_builder = StepBuilder.new(klass)
      end

      def call
        logicals.each_with_index { |step, i| step.is_a?(Failure) ? link_failure(step, i) : link_step(step, i) }
        logicals.first
      end

      private

      def logicals
        @logicals ||= @steps.map { |step| @step_builder.call(**step) }
      end

      def link_step(step, index)
        next_step = logicals[index.next..-1].detect { |next_node| !next_node.is_a?(Failure) }
        step.add_next_step(step.on_success ? find_step(step.on_success) : next_step)
        step.add_failure(next_step) if step.is_a?(Pass)
        step.add_failure(find_step(step.on_failure)) if step.on_failure
      end

      def link_failure(failure, index)
        link_previous_steps(failure, index)
        failure.add_next_step(find_step(failure.on_success)) if failure.on_success
        failure.add_failure(find_step(failure.on_failure)) if failure.on_failure
      end

      def link_previous_steps(failure, index)
        logicals[0...index].reverse_each do |previous_step|
          previous_step.add_failure(failure) unless previous_step.on_failure || previous_step.is_a?(Pass)
          next unless previous_step.is_a?(Failure)

          previous_step.add_next_step(failure) unless previous_step.on_success
          break
        end
      end

      def find_step(name)
        @steps_by_name ||= logicals.group_by(&:name).transform_values(&:first)
        @steps_by_name[name] || raise(StepIsNotImplementedError.new(@klass, name))
      end
    end
  end
end
