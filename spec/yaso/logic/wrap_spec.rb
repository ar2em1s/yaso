# frozen_string_literal: true

RSpec.describe Yaso::Logic::Wrap do
  describe '#call' do
    subject(:result) { step.call(context, instance_double(Yaso::Service)) }

    let(:step) { described_class.new(name: nil, invokable: invokable, wrapper: wrapper) }
    let(:invokable) do
      proc do |&block|
        block.call
        true
      end
    end
    # rubocop:disable RSpec/VerifiedDoubles
    let(:wrapper) { double('Wrapper') }
    # rubocop:enable RSpec/VerifiedDoubles
    let(:context) { Yaso::Context.new({}) }

    before { allow(wrapper).to receive(:call).and_return(Yaso::Context.new({})) }

    it 'calls wrapper' do
      result
      expect(wrapper).to have_received(:call)
    end

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
      let(:invokable) { proc { false } }

      before { step.add_failure(failure) }

      it 'returns failure' do
        expect(result).to eq(failure)
      end

      it 'changes context status to failure' do
        result
        expect(context).to be_failure
      end
    end

    context 'when step fails and failure is not defined' do
      let(:invokable) { proc { false } }

      it 'returns nil' do
        expect(result).to be_nil
      end

      it 'changes context status to failure' do
        result
        expect(context).to be_failure
      end
    end
  end
end
