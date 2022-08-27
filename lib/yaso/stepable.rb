# frozen_string_literal: true

module Yaso
  module Stepable
    def steps
      @steps ||= []
    end

    %i[step pass wrap switch].each do |category|
      define_method(category) do |object, **options, &block|
        steps << {
          object: object, category: category, fast: options.delete(:fast), on_success: options.delete(:on_success),
          on_failure: options.delete(:on_failure), options: options, block: block, name: options.delete(:name)
        }
      end
    end

    def failure(object, **options, &block)
      raise InvalidFirstStepError, :failure if flow == Logic::Classic && steps.empty?

      steps << {
        object: object, category: :failure, fast: options.delete(:fast), on_success: options.delete(:on_success),
        on_failure: options.delete(:on_failure), options: options, block: block, name: options.delete(:name)
      }
    end
  end
end
