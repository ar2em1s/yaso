puts "Ruby: #{RUBY_DESCRIPTION}"
puts "Step Benchmark"

puts "Services with 10 simple steps"
Benchmark.ips do |x|
  x.config(stats: :bootstrap, confidence: 95)

  x.report("Pure Service") { PureStepsService.call }
  x.report("SimpleCommand") { SimpleCommandStepsService.call }
  x.report("SimpleLogicStep") { SimpleLogicStepStepsService.call }
  x.report("Yaso") { YasoStepsService.call }
  x.report("Decouplio") { DecouplioStepsService.call }
  x.report("Interactor") { InteractorStepsService.call }
  x.report("ActiveInteraction") { ActiveInteractionStepsService.run }
  x.report("Trailblazer") { TrailblazerStepsService.call }
  x.report("DryTransaction") { DryTransactionStepsService.new.call({}) }

  x.compare!
end

puts "Services with 10 callable steps"
Benchmark.ips do |x|
  x.config(stats: :bootstrap, confidence: 95)

  x.report("Pure Service") { PureCallablesService.call }
  x.report("SimpleCommand") { SimpleCommandCallablesService.call }
  x.report("SimpleLogicStep") { SimpleLogicStepCallablesService.call }
  x.report("Yaso") { YasoCallablesService.call }
  x.report("Decouplio") { DecouplioCallablesService.call }
  x.report("Interactor") { InteractorCallablesService.call }
  x.report("ActiveInteraction") { ActiveInteractionCallablesService.run }
  x.report("Trailblazer") { TrailblazerCallablesService.call }
  x.report("DryTransaction") { DryTransactionCallablesService.new.call({}) }

  x.compare!
end
