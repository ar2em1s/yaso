class CallableStep
  def self.call(ctx, key:, value:, **)
    ctx[key] = value
  end
end
