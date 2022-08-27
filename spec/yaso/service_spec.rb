# frozen_string_literal: true

RSpec.describe Yaso::Service do
  describe '.call' do
    subject(:result) { Class.new(described_class).call(params) }

    let(:params) { { one: FFaker::Lorem.word } }
    let(:entry) { instance_double(Yaso::Logic::Base) }

    before do
      allow(Yaso::Logic::Classic).to receive(:call).and_return(entry)
      allow(entry).to receive(:call)
    end

    it 'creates a new context' do
      allow(Yaso::Context).to receive(:new)
      result
      expect(Yaso::Context).to have_received(:new).with(params).once
    end

    context 'when context is passed' do
      let!(:params) { Yaso::Context.new({}) }

      it 'does not create a new context' do
        allow(Yaso::Context).to receive(:new)
        result
        expect(Yaso::Context).not_to have_received(:new)
      end
    end

    it 'calls Flow to build a graph on the first call' do
      result
      expect(Yaso::Logic::Classic).to have_received(:call)
    end

    context 'when service is called more than once' do
      subject(:klass) { Class.new(described_class) }

      it 'calls Flow only on the first call' do
        2.times { klass.call(params) }
        expect(Yaso::Logic::Classic).to have_received(:call).once
      end
    end

    it 'calls entry' do
      result
      expect(entry).to have_received(:call)
    end

    it 'returns a context' do
      expect(result).to be_a(Yaso::Context)
    end
  end

  describe '.flow' do
    subject(:klass) { described_class }

    after { described_class.flow :classic }

    describe 'when no params are passed' do
      it 'returns Yaso::Logic::Classic' do
        expect(klass.flow).to eq Yaso::Logic::Classic
      end
    end

    describe 'when flow name is passed' do
      let!(:child_class) { Class.new(described_class) }

      before { klass.flow(:rollback) }

      it 'returns specified flow class' do
        expect(klass.flow).to eq Yaso::Logic::Rollback
      end

      it 'sets flow for child classes' do
        expect(child_class.flow).to eq Yaso::Logic::Rollback
      end
    end

    describe 'when flow is set for child class' do
      subject(:klass) { Class.new(described_class) }

      let!(:another_class) { Class.new(described_class) }

      before { klass.flow(:rollback) }

      it 'returns specified flow class' do
        expect(klass.flow).to eq Yaso::Logic::Rollback
      end

      it 'does not set flow for Yaso::Service' do
        expect(described_class.flow).to eq Yaso::Logic::Classic
      end

      it 'does not set flow for another services' do
        expect(another_class.flow).to eq Yaso::Logic::Classic
      end
    end
  end
end
