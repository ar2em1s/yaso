# frozen_string_literal: true

class YasoStepsService < YasoService
  step :one
  step :two
  step :three
  step :four
  step :five
  step :six
  step :seven
  step :eight
  step :nine
  step :ten

  def one(ctx, **)
    ctx[:one] = true
  end

  def two(ctx, **)
    ctx[:two] = true
  end

  def three(ctx, **)
    ctx[:three] = true
  end

  def four(ctx, **)
    ctx[:four] = true
  end

  def five(ctx, **)
    ctx[:five] = true
  end

  def six(ctx, **)
    ctx[:six] = true
  end

  def seven(ctx, **)
    ctx[:seven] = true
  end

  def eight(ctx, **)
    ctx[:eight] = true
  end

  def nine(ctx, **)
    ctx[:nine] = true
  end

  def ten(ctx, **)
    ctx[:ten] = true
  end
end

class YasoCallablesService < YasoService
  step CallableStep, key: :one, value: true
  step CallableStep, key: :two, value: true
  step CallableStep, key: :three, value: true
  step CallableStep, key: :four, value: true
  step CallableStep, key: :five, value: true
  step CallableStep, key: :six, value: true
  step CallableStep, key: :seven, value: true
  step CallableStep, key: :eight, value: true
  step CallableStep, key: :nine, value: true
  step CallableStep, key: :ten, value: true
end
