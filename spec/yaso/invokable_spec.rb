# frozen_string_literal: true

RSpec.describe Yaso::Invokable do
  describe '.call' do
    subject(:invokable) { described_class.call(object, options: options).last }

    let(:result) { invokable.call(context, instance) }
    let(:object) { :foo }
    let(:options) { {} }
    let(:context) { instance_double(Yaso::Context) }
    # rubocop:disable RSpec/VerifiedDoubles
    let(:instance) { double(Yaso::Service) }
    # rubocop:enable RSpec/VerifiedDoubles

    context 'when Yaso::Invokable::METHOD' do
      before do
        allow(context).to receive(:data).and_return({})
        allow(instance).to receive(:foo)
        result
      end

      it 'calls the instance method' do
        expect(instance).to have_received(:foo)
      end

      it 'calls Yaso::Context#to_h!' do
        expect(context).to have_received(:data)
      end
    end

    context 'when Yaso::Invokable::YASO' do
      let(:object) { Yaso::Service }

      before do
        nested_context = instance_double(Yaso::Context)
        allow(nested_context).to receive(:success?)
        allow(object).to receive(:call).and_return(nested_context)
        result
      end

      it 'invokes the service' do
        expect(object).to have_received(:call)
      end
    end

    context 'when Yaso::Invokable::CALLABLE' do
      let(:object) { Class.new }
      let(:options) { { FFaker::Lorem.word.to_sym => FFaker::Lorem.word } }

      before do
        allow(object).to receive(:call)
        allow(instance).to receive(:foo)
        result
      end

      it 'invokes the constant' do
        expect(object).to have_received(:call).with(context, **options)
      end
    end
  end
end
