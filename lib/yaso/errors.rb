module Yaso
  class Error < StandardError; end

  class StepIsNotImplementedError < Error
    def initialize(klass, step)
      super("#{klass}##{step} step is not implemented")
    end
  end

  class InvalidFirstStepError < Error
    def initialize(category)
      super("#{category.to_s.capitalize} cannot be the first step")
    end
  end

  class UnhandledSwitchCaseError < Error
    def initialize(klass)
      super("Unhandled switch case in #{klass}")
    end
  end

  class UnknownFlowError < Error
    def initialize(klass, name)
      super("Unknown flow \"#{name}\" is set in #{klass}")
    end
  end
end
