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
end
