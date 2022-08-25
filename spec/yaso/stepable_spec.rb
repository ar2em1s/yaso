# frozen_string_literal: true

RSpec.describe Yaso::Stepable do
  subject(:klass) { Class.new { extend Yaso::Stepable } }

  describe '.steps' do
    it 'returns empty array' do
      expect(klass.steps).to eq([])
    end

    context 'when step was added' do
      let(:step) { FFaker::Lorem.word }

      before { klass.steps << step }

      it 'returns array with steps' do
        expect(klass.steps).to eq([step])
      end
    end
  end

  describe '.step' do
    let(:step) { FFaker::Lorem.word }
    let(:expected_steps) do
      [
        {
          object: step, category: :step, fast: nil, on_success: nil, on_failure: nil, options: {}, block: nil, name: nil
        }
      ]
    end

    it 'saves step to steps' do
      klass.step step
      expect(klass.steps).to eq(expected_steps)
    end

    context 'with additional options' do
      let(:options) do
        { fast: true, on_success: :success_name, on_failure: :failure_name, custom_option: 1, name: FFaker::Lorem.word }
      end
      let(:step_block) { -> {} }
      let(:expected_steps) do
        [
          {
            object: step, category: :step, fast: options[:fast], on_success: options[:on_success],
            on_failure: options[:on_failure], options: options.slice(:custom_option), block: step_block,
            name: options[:name]
          }
        ]
      end

      it 'saves step to steps with options' do
        klass.step step, **options, &step_block
        expect(klass.steps).to eq(expected_steps)
      end
    end
  end

  describe '.failure' do
    let(:failure) { FFaker::Lorem.word }
    let(:expected_steps) do
      [
        :first_step,
        {
          object: failure, category: :failure, fast: nil, on_success: nil,
          on_failure: nil, options: {}, block: nil, name: nil
        }
      ]
    end

    before { klass.steps << :first_step }

    it 'saves failure to steps' do
      klass.failure failure
      expect(klass.steps).to eq(expected_steps)
    end

    context 'with additional options' do
      let(:options) do
        { fast: true, on_success: :success_name, on_failure: :failure_name, custom_option: 1, name: FFaker::Lorem.word }
      end
      let(:step_block) { -> {} }
      let(:expected_steps) do
        [
          :first_step,
          {
            object: failure, category: :failure, fast: options[:fast], on_success: options[:on_success],
            on_failure: options[:on_failure], options: options.slice(:custom_option), block: step_block,
            name: options[:name]
          }
        ]
      end

      it 'saves failure to steps with options' do
        klass.failure failure, **options, &step_block
        expect(klass.steps).to eq(expected_steps)
      end
    end

    context 'when failure is the first step' do
      before { klass.steps.clear }

      it 'raises InvalidFirstStepError' do
        expect { klass.failure(failure) }.to raise_error(Yaso::InvalidFirstStepError)
      end
    end
  end

  describe '.pass' do
    let(:pass) { FFaker::Lorem.word }
    let(:expected_steps) do
      [
        {
          object: pass, category: :pass, fast: nil, on_success: nil, on_failure: nil, options: {}, block: nil, name: nil
        }
      ]
    end

    it 'saves pass to steps' do
      klass.pass pass
      expect(klass.steps).to eq(expected_steps)
    end

    context 'with additional options' do
      let(:options) do
        { fast: true, on_success: :success_name, on_failure: :failure_name, custom_option: 1, name: FFaker::Lorem.word }
      end
      let(:step_block) { -> {} }
      let(:expected_steps) do
        [
          {
            object: pass, category: :pass, fast: options[:fast], on_success: options[:on_success],
            on_failure: options[:on_failure], options: options.slice(:custom_option), block: step_block,
            name: options[:name]
          }
        ]
      end

      it 'saves pass to steps with options' do
        klass.pass pass, **options, &step_block
        expect(klass.steps).to eq(expected_steps)
      end
    end
  end

  describe '.wrap' do
    let(:wrap) { FFaker::Lorem.word }
    let(:expected_steps) do
      [
        {
          object: wrap, category: :wrap, fast: nil, on_success: nil, on_failure: nil, options: {}, block: nil, name: nil
        }
      ]
    end

    it 'saves wrap to steps' do
      klass.wrap wrap
      expect(klass.steps).to eq(expected_steps)
    end

    context 'with additional options' do
      let(:options) do
        { fast: true, on_success: :success_name, on_failure: :failure_name, custom_option: 1, name: FFaker::Lorem.word }
      end
      let(:step_block) { -> {} }
      let(:expected_steps) do
        [
          {
            object: wrap, category: :wrap, fast: options[:fast], on_success: options[:on_success],
            on_failure: options[:on_failure], options: options.slice(:custom_option), block: step_block,
            name: options[:name]
          }
        ]
      end

      it 'saves wrap to steps with options' do
        klass.wrap wrap, **options, &step_block
        expect(klass.steps).to eq(expected_steps)
      end
    end
  end
end
