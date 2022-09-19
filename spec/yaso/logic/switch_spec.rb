# frozen_string_literal: true

RSpec.describe Yaso::Logic::Switch do
  describe '#call' do
    subject(:result) { step.call({}, instance_double(Yaso::Service)) }

    let(:step) { described_class.new(name: nil, invocable: invocable) }
    let(:invocable) { proc { :method_name } }

    context 'when invocable returns nil' do
      let(:invocable) { proc {} }

      it 'raises UnhandledSwitchCase' do
        expect { result }.to raise_error(Yaso::UnhandledSwitchCaseError)
      end
    end

    context 'when switch case returns true' do
      before { allow(Yaso::Invocable).to receive(:call).and_return([nil, proc { true }]) }

      it 'returns nil and true' do
        expect(result).to eq([nil, true])
      end
    end

    context 'when switch case returns true and next step exists' do
      let(:next_step) { instance_double(Yaso::Logic::Base) }

      before do
        allow(Yaso::Invocable).to receive(:call).and_return([nil, proc { true }])
        step.add_next_step(next_step)
      end

      it 'returns next_step and true' do
        expect(result).to eq([next_step, true])
      end
    end

    context 'when switch case returns false' do
      before { allow(Yaso::Invocable).to receive(:call).and_return([nil, proc { false }]) }

      it 'returns nil and false' do
        expect(result).to eq([nil, false])
      end
    end

    context 'when switch case returns false and failure exists' do
      let(:failure) { instance_double(Yaso::Logic::Base) }

      before do
        allow(Yaso::Invocable).to receive(:call).and_return([nil, proc { false }])
        step.add_failure(failure)
      end

      it 'returns failure and false' do
        expect(result).to eq([failure, false])
      end
    end
  end
end
