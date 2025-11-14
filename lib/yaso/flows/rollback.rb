module Yaso
  module Flows
    class Rollback < Classic
      def call
        super
        logicals.detect { |step| !step.is_a?(Steps::Failure) }
      end

      private

      def link_step(step, index)
        next_success = step.on_success ? find_step(step.on_success) : next_step(index)
        next_failure = if step.on_failure then find_step(step.on_failure)
        else
          step.is_a?(Steps::Pass) ? next_success : previous_failure(index)
        end

        step.add_next_step(next_success)
        step.add_failure(next_failure)
      end

      def link_previous_steps(failure, index)
        prev_failure = previous_failure(index)

        failure.add_failure(prev_failure) unless failure.on_failure
        failure.add_next_step(prev_failure) unless failure.on_success
      end

      def next_step(index)
        logicals[index.next..].detect { |next_node| !next_node.is_a?(Steps::Failure) }
      end

      def previous_failure(index)
        logicals[0...index].reverse_each.detect { |previous_step| previous_step.is_a?(Steps::Failure) }
      end
    end
  end
end
