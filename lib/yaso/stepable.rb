# frozen_string_literal: true

module Yaso
  module Stepable
    def steps
      @steps ||= []
    end

    %i[step pass failure wrap switch].each do |category|
      define_method(category) do |object, options = {}, &block|
        raise InvalidFirstStepError, category if category == :failure && steps.empty?

        steps << {
          object: object, category: category, fast: options.delete(:fast), on_success: options.delete(:on_success),
          on_failure: options.delete(:on_failure), options: options, block: block, name: options.delete(:name)
        }
      end
    end
  end
end
