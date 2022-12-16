# frozen_string_literal: true

class DryTransactionStepsService
  include Dry::Transaction

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

  private

  def one(ctx)
    ctx[:one] = true
    Success(ctx)
  end

  def two(ctx)
    ctx[:two] = true
    Success(ctx)
  end

  def three(ctx)
    ctx[:three] = true
    Success(ctx)
  end

  def four(ctx)
    ctx[:four] = true
    Success(ctx)
  end

  def five(ctx)
    ctx[:five] = true
    Success(ctx)
  end

  def six(ctx)
    ctx[:six] = true
    Success(ctx)
  end

  def seven(ctx)
    ctx[:seven] = true
    Success(ctx)
  end

  def eight(ctx)
    ctx[:eight] = true
    Success(ctx)
  end

  def nine(ctx)
    ctx[:nine] = true
    Success(ctx)
  end

  def ten(ctx)
    ctx[:ten] = true
    Success(ctx)
  end
end

class DryTansactionCallable
  include Dry::Transaction::Operation

  def initialize(key)
    @key = key
  end

  def call(ctx)
    ctx[@key] = true
    Success(ctx)
  end
end

class DryTransactionContainer
  extend Dry::Container::Mixin

  namespace :callable do
    register(:one) { DryTansactionCallable.new(:one) }
    register(:two) { DryTansactionCallable.new(:two) }
    register(:three) { DryTansactionCallable.new(:three) }
    register(:four) { DryTansactionCallable.new(:four) }
    register(:five) { DryTansactionCallable.new(:five) }
    register(:six) { DryTansactionCallable.new(:six) }
    register(:seven) { DryTansactionCallable.new(:seven) }
    register(:eight) { DryTansactionCallable.new(:eight) }
    register(:nine) { DryTansactionCallable.new(:nine) }
    register(:ten) { DryTansactionCallable.new(:ten) }
  end
end

class DryTransactionCallablesService
  include Dry::Transaction(container: DryTransactionContainer)

  step :one, with: :'callable.one'
  step :two, with: :'callable.two'
  step :three, with: :'callable.three'
  step :four, with: :'callable.four'
  step :five, with: :'callable.five'
  step :six, with: :'callable.six'
  step :seven, with: :'callable.seven'
  step :eight, with: :'callable.eight'
  step :nine, with: :'callable.nine'
  step :ten, with: :'callable.ten'
end
