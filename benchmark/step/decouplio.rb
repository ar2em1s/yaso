class DecouplioStepsService < DecouplioService
  logic do
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
  end

  def one
    ctx[:one] = true
  end

  def two
    ctx[:two] = true
  end

  def three
    ctx[:three] = true
  end

  def four
    ctx[:four] = true
  end

  def five
    ctx[:five] = true
  end

  def six
    ctx[:six] = true
  end

  def seven
    ctx[:seven] = true
  end

  def eight
    ctx[:eight] = true
  end

  def nine
    ctx[:nine] = true
  end

  def ten
    ctx[:ten] = true
  end
end

class DecouplioCallableStep
  def self.call(ctx, _, key:, value:)
    ctx[key] = value
  end
end

class DecouplioCallablesService < DecouplioService
  logic do
    step DecouplioCallableStep, key: :one, value: true
    step DecouplioCallableStep, key: :two, value: true
    step DecouplioCallableStep, key: :three, value: true
    step DecouplioCallableStep, key: :four, value: true
    step DecouplioCallableStep, key: :five, value: true
    step DecouplioCallableStep, key: :six, value: true
    step DecouplioCallableStep, key: :seven, value: true
    step DecouplioCallableStep, key: :eight, value: true
    step DecouplioCallableStep, key: :nine, value: true
    step DecouplioCallableStep, key: :ten, value: true
  end
end
