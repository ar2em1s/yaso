# frozen_string_literal: true

RSpec.describe Yaso::Context do
  subject(:context) { described_class.new(params) }

  let(:params) { {} }

  describe '#[]' do
    let(:params) { { key => value } }
    let(:key) { FFaker::Lorem.word }
    let(:value) { FFaker::Lorem.word }

    it 'returns the value' do
      expect(context[key]).to eq(value)
    end
  end

  describe '#[]=' do
    let(:key) { FFaker::Lorem.word }
    let(:value) { FFaker::Lorem.word }

    before { context[key] = value }

    it 'stores the value' do
      expect(context[key]).to eq(value)
    end
  end

  describe '#to_h' do
    it 'returns deep copy of the data' do
      expect(context.to_h).to be_a(Hash)
    end
  end

  describe '#success?' do
    context 'when context is success' do
      it 'returns true' do
        expect(context.success?).to be(true)
      end
    end

    context 'when context is failed' do
      before { context.success = false }

      it 'returns false' do
        expect(context.success?).to be(false)
      end
    end
  end

  describe '#failure?' do
    context 'when context is success' do
      it 'returns false' do
        expect(context.failure?).to be(false)
      end
    end

    context 'when context is failed' do
      before { context.success = false }

      it 'returns true' do
        expect(context.failure?).to be(true)
      end
    end
  end
end
