class InteractorStepsService < InteractorService
  def call
    one
    two
    three
    four
    five
    six
    seven
    eight
    nine
    ten
  end

  def one
    context.one = true
  end

  def two
    context.two = true
  end

  def three
    context.three = true
  end

  def four
    context.four = true
  end

  def five
    context.five = true
  end

  def six
    context.six = true
  end

  def seven
    context.seven = true
  end

  def eight
    context.eight = true
  end

  def nine
    context.nine = true
  end

  def ten
    context.ten = true
  end
end

class InteractorCallableStep < InteractorService
  def call
    context.one = true
  end
end

class InteractorCallablesService < InteractorOrganizer
  organize InteractorCallableStep,
    InteractorCallableStep,
    InteractorCallableStep,
    InteractorCallableStep,
    InteractorCallableStep,
    InteractorCallableStep,
    InteractorCallableStep,
    InteractorCallableStep,
    InteractorCallableStep,
    InteractorCallableStep
end
