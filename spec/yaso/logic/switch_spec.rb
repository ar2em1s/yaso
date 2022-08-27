# frozen_string_literal: true

RSpec.describe Yaso::Logic::Switch do
  describe '#call' do
    subject(:result) { step.call(context, instance_double(Yaso::Service)) }

    let(:step) { described_class.new(name: nil, invocable: invocable) }
    let(:invocable) { proc { :method_name } }
    let(:context) { Yaso::Context.new({}) }

    context 'when invocable returns nil' do
      let(:invocable) { proc {} }

      it 'raises UnhandledSwitchCase' do
        expect { result }.to raise_error(Yaso::UnhandledSwitchCaseError)
      end
    end

    context 'when switch case returns true' do
      before { allow(Yaso::Invocable).to receive(:call).and_return([nil, proc { true }]) }

      it 'returns nil' do
        expect(result).to be_nil
      end

      it 'succeeds context' do
        result
        expect(context).to be_success
      end
    end

    context 'when switch case returns true and next step exists' do
      let(:next_step) { instance_double(Yaso::Logic::Base) }

      before do
        allow(Yaso::Invocable).to receive(:call).and_return([nil, proc { true }])
        step.add_next_step(next_step)
      end

      it 'returns next_step' do
        expect(result).to eq(next_step)
      end

      it 'succeeds context' do
        result
        expect(context).to be_success
      end
    end

    context 'when switch case returns false' do
      before { allow(Yaso::Invocable).to receive(:call).and_return([nil, proc { false }]) }

      it 'returns nil' do
        expect(result).to be_nil
      end

      it 'fails context' do
        result
        expect(context).to be_failure
      end
    end

    context 'when switch case returns false and failure exists' do
      let(:failure) { instance_double(Yaso::Logic::Base) }

      before do
        allow(Yaso::Invocable).to receive(:call).and_return([nil, proc { false }])
        step.add_failure(failure)
      end

      it 'returns failure' do
        expect(result).to eq(failure)
      end

      it 'fails context' do
        result
        expect(context).to be_failure
      end
    end
  end
end
