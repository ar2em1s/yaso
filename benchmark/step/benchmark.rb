# frozen_string_literal: true

puts 'Step Benchmark'

puts 'Services with 10 simple steps'
Benchmark.ips do |x|
  x.config(stats: :bootstrap, confidence: 95)

  x.report('Pure Service') { PureStepsService.call }
  x.report('Yaso') { YasoStepsService.call }
  x.report('Decouplio') { DecouplioStepsService.call } unless RUBY_VERSION.include?('2.5')
  x.report('Interactor') { InteractorStepsService.call }
  x.report('ActiveInteraction') { ActiveInteractionStepsService.run }
  x.report('Trailblazer') { TrailblazerStepsService.call }

  x.compare!
end

puts 'Services with 10 callable steps'
Benchmark.ips do |x|
  x.config(stats: :bootstrap, confidence: 95)

  x.report('Pure Service') { PureCallablesService.call }
  x.report('Yaso') { YasoCallablesService.call }
  x.report('Decouplio') { DecouplioCallablesService.call } unless RUBY_VERSION.include?('2.5')
  x.report('Interactor') { InteractorCallablesService.call }
  x.report('ActiveInteraction') { ActiveInteractionCallablesService.run }
  x.report('Trailblazer') { TrailblazerCallablesService.call }

  x.compare!
end
