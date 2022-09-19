# frozen_string_literal: true

RSpec.describe Yaso::Service do
  subject(:result) { described_class.new(params) }

  let(:params) { {} }

  describe '#[]' do
    let(:params) { { key => value } }
    let(:key) { FFaker::Lorem.word }
    let(:value) { FFaker::Lorem.word }

    it 'returns the value' do
      expect(result[key]).to eq(value)
    end
  end

  describe '#[]=' do
    let(:key) { FFaker::Lorem.word }
    let(:value) { FFaker::Lorem.word }

    before { result[key] = value }

    it 'stores the value' do
      expect(result[key]).to eq(value)
    end
  end

  describe '#to_h' do
    let(:params) { { one: FFaker::Lorem.word } }

    it 'returns deep copy of the data' do
      expect(result.to_h).to eq(params)
    end
  end

  describe '#success?' do
    context 'when result is success' do
      it 'returns true' do
        expect(result).to be_success
      end
    end

    context 'when result is failed' do
      before { result.success = false }

      it 'returns false' do
        expect(result).not_to be_success
      end
    end
  end

  describe '#failure?' do
    context 'when result is success' do
      it 'returns false' do
        expect(result).not_to be_failure
      end
    end

    context 'when result is failed' do
      before { result.success = false }

      it 'returns true' do
        expect(result).to be_failure
      end
    end
  end

  describe '#inspect' do
    let(:params) { { one: FFaker::Lorem.word } }
    let(:expected_output) { "Result:#{result.class} successful: #{result.success?}, context: #{params}" }

    it 'returns result description' do
      expect(result.inspect).to eq(expected_output)
    end
  end

  describe '.call' do
    subject(:result) { Class.new(described_class).call(params) }

    let(:params) { { one: FFaker::Lorem.word } }
    let(:entry) { instance_double(Yaso::Logic::Base) }

    before do
      allow(Yaso::Logic::Classic).to receive(:call).and_return(entry)
      allow(entry).to receive(:call)
    end

    it 'creates a new service instance' do
      allow(described_class).to receive(:new).and_call_original
      result
      expect(described_class).to have_received(:new).with(params).once
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

    it 'returns a result' do
      expect(result).to be_a(described_class)
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
