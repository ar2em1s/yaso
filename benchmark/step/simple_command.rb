# frozen_string_literal: true

class SimpleCommandStepsService < SimpleCommandService
  # rubocop:disable Metrics/MethodLength
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
    ctx
  end
  # rubocop:enable Metrics/MethodLength

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

class SimpleCommandCallablesService < SimpleCommandService
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def call
    CallableStep.call(ctx, key: :one, value: true)
    CallableStep.call(ctx, key: :two, value: true)
    CallableStep.call(ctx, key: :three, value: true)
    CallableStep.call(ctx, key: :four, value: true)
    CallableStep.call(ctx, key: :five, value: true)
    CallableStep.call(ctx, key: :six, value: true)
    CallableStep.call(ctx, key: :seven, value: true)
    CallableStep.call(ctx, key: :eight, value: true)
    CallableStep.call(ctx, key: :nine, value: true)
    CallableStep.call(ctx, key: :ten, value: true)
    ctx
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
