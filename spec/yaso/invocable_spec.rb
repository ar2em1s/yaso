# frozen_string_literal: true

RSpec.describe Yaso::Invocable do
  describe '.call' do
    subject(:invocable) { described_class.call(object, options: options).last }

    let(:result) { invocable.call(context, instance) }
    let(:object) { :foo }
    let(:options) { {} }
    let(:context) { { one: FFaker::Lorem.word } }
    # rubocop:disable RSpec/VerifiedDoubles
    let(:instance) { double(Yaso::Service) }
    # rubocop:enable RSpec/VerifiedDoubles

    context 'when Yaso::Invocable::METHOD' do
      before do
        allow(instance).to receive(:foo)
        result
      end

      it 'calls the instance method' do
        expect(instance).to have_received(:foo).with(context, **context)
      end
    end

    context 'when Yaso::Invocable::YASO' do
      let(:object) { Yaso::Service }

      before do
        nested_service = instance_double(Yaso::Service)
        allow(nested_service).to receive(:success?)
        allow(object).to receive(:call).and_return(nested_service)
        result
      end

      it 'invokes the service' do
        expect(object).to have_received(:call).with(context)
      end
    end

    context 'when Yaso::Invocable::CALLABLE' do
      let(:object) { Class.new }
      let(:options) { { FFaker::Lorem.word.to_sym => FFaker::Lorem.word } }

      before do
        allow(object).to receive(:call)
        result
      end

      it 'invokes the constant' do
        expect(object).to have_received(:call).with(context, **options)
      end
    end
  end
end
