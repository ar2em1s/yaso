class ActiveInteractionStepsService < ActiveInteractionService
  hash :ctx, default: {}

  def execute
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

  private

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

class ActiveInteractionCallableStep < ActiveInteractionService
  hash :ctx
  symbol :key
  boolean :value

  def execute
    ctx[key] = value
  end
end

class ActiveInteractionCallablesService < ActiveInteractionService
  hash :ctx, default: {}

  # rubocop:disable Metrics/AbcSize
  def execute
    compose(ActiveInteractionCallableStep, ctx: ctx, key: :one, value: true)
    compose(ActiveInteractionCallableStep, ctx: ctx, key: :two, value: true)
    compose(ActiveInteractionCallableStep, ctx: ctx, key: :three, value: true)
    compose(ActiveInteractionCallableStep, ctx: ctx, key: :four, value: true)
    compose(ActiveInteractionCallableStep, ctx: ctx, key: :five, value: true)
    compose(ActiveInteractionCallableStep, ctx: ctx, key: :six, value: true)
    compose(ActiveInteractionCallableStep, ctx: ctx, key: :seven, value: true)
    compose(ActiveInteractionCallableStep, ctx: ctx, key: :eight, value: true)
    compose(ActiveInteractionCallableStep, ctx: ctx, key: :nine, value: true)
    compose(ActiveInteractionCallableStep, ctx: ctx, key: :ten, value: true)
  end
  # rubocop:enable Metrics/AbcSize
end
