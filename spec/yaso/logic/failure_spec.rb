# frozen_string_literal: true

RSpec.describe Yaso::Logic::Failure do
  describe '#call' do
    subject(:result) { step.call(context, instance_double(Yaso::Service)) }

    let(:step) { described_class.new(name: nil, invocable: invocable) }
    let(:invocable) { proc { true } }
    let(:context) { Yaso::Context.new({}) }

    context 'when next_step exists' do
      let(:next_step) { instance_double(Yaso::Logic::Base) }

      before { step.add_next_step(next_step) }

      it 'returns the next step' do
        expect(result).to eq(next_step)
      end
    end

    context 'when next_step is not defined' do
      it 'returns nil' do
        expect(result).to be_nil
      end
    end

    context 'when step fails and failure exists' do
      let(:failure) { instance_double(Yaso::Logic::Base) }
      let(:invocable) { proc { false } }

      before { step.add_failure(failure) }

      it 'returns failure' do
        expect(result).to eq(failure)
      end
    end

    context 'when step fails and failure is not defined' do
      let(:invocable) { proc { false } }

      it 'returns nil' do
        expect(result).to be_nil
      end
    end

    context 'when context succeeds before' do
      before do
        context.success = true
        result
      end

      it 'changes context status to failure' do
        expect(context).to be_failure
      end
    end
  end
end
