# frozen_string_literal: true

RSpec.describe Yaso::Logic::Wrap do
  describe '#call' do
    subject(:result) { step.call({}, instance) }

    let(:step) { described_class.new(name: nil, invocable: invocable, wrapper: wrapper) }
    let(:invocable) { proc { |&block| block.call } }
    # rubocop:disable RSpec/VerifiedDoubles
    let(:wrapper) { double('Wrapper') }
    # rubocop:enable RSpec/VerifiedDoubles
    let(:instance) { instance_double(Yaso::Service) }

    before do
      allow(instance).to receive(:success=)
      allow(instance).to receive(:success?).and_return(true)
      allow(wrapper).to receive(:call).and_return(instance)
    end

    it 'calls wrapper' do
      result
      expect(wrapper).to have_received(:call)
    end

    context 'when next_step exists' do
      let(:next_step) { instance_double(Yaso::Logic::Base) }

      before { step.add_next_step(next_step) }

      it 'returns the next step and true' do
        expect(result).to eq(next_step)
      end
    end

    context 'when next_step is not defined' do
      it 'returns nil and true' do
        expect(result).to be_nil
      end
    end

    context 'when step fails and failure exists' do
      let(:failure) { instance_double(Yaso::Logic::Base) }

      before do
        allow(instance).to receive(:success?).and_return(false)
        step.add_failure(failure)
      end

      it 'returns failure and false' do
        expect(result).to eq(failure)
      end
    end

    context 'when step fails and failure is not defined' do
      before { allow(instance).to receive(:success?).and_return(false) }

      it 'returns nil' do
        expect(result).to be_nil
      end
    end
  end
end
