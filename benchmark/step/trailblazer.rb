# frozen_string_literal: true

class TrailblazerStepsService < TrailblazerService
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

module TrailblazerMacro
  # rubocop:disable Naming/MethodName
  def self.CallableStep(key:, value:)
    id = :"CallableStep.#{key}"
    step = lambda do |ctx, **|
      ctx[key] = value
      return true if ctx[key]

      ctx[:"result.#{id}"] = Trailblazer::Operation::Result.new(false, {})
      false
    end
    task = Trailblazer::Activity::Circuit::TaskAdapter.for_step(step)
    { task: task, id: id }
  end
  # rubocop:enable Naming/MethodName
end

class TrailblazerCallablesService < TrailblazerService
  step TrailblazerMacro::CallableStep(key: :one, value: true)
  step TrailblazerMacro::CallableStep(key: :two, value: true)
  step TrailblazerMacro::CallableStep(key: :three, value: true)
  step TrailblazerMacro::CallableStep(key: :four, value: true)
  step TrailblazerMacro::CallableStep(key: :five, value: true)
  step TrailblazerMacro::CallableStep(key: :six, value: true)
  step TrailblazerMacro::CallableStep(key: :seven, value: true)
  step TrailblazerMacro::CallableStep(key: :eight, value: true)
  step TrailblazerMacro::CallableStep(key: :nine, value: true)
  step TrailblazerMacro::CallableStep(key: :ten, value: true)
end
