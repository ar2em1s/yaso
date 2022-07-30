# frozen_string_literal: true

module ServiceClassHelpers
  def create_service(&block)
    Class.new(Yaso::Service, &block)
  end
end
