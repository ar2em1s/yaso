# frozen_string_literal: true

puts 'Step Benchmark'

puts 'Services with 10 simple steps'
Benchmark.ips do |x|
  x.config(stats: :bootstrap, confidence: 95)

  x.report('Pure Service') { PureStepsService.call }
  x.report('Decouplio Service') { DecouplioStepsService.call } unless RUBY_VERSION.include?('2.5')
  x.report('Yaso Service') { YasoStepsService.call }
  x.report('Interactor Service') { InteractorStepsService.call }
  x.report('ActiveInteraction Service') { ActiveInteractionStepsService.run }
  x.report('Trailblazer Service') { TrailblazerStepsService.call }

  x.compare!
end

puts 'Services with 10 callable steps'
Benchmark.ips do |x|
  x.config(stats: :bootstrap, confidence: 95)

  x.report('Pure Service') { PureCallablesService.call }
  x.report('Decouplio Service') { DecouplioCallablesService.call } unless RUBY_VERSION.include?('2.5')
  x.report('Yaso Service') { YasoCallablesService.call }
  x.report('Interactor Service') { InteractorCallablesService.call }
  x.report('ActiveInteraction Service') { ActiveInteractionCallablesService.run }
  x.report('Trailblazer Service') { TrailblazerCallablesService.call }

  x.compare!
end
