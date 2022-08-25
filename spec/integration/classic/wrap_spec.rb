# frozen_string_literal: true

RSpec.describe 'Wrap', type: :integration do
  subject(:klass) do
    create_service do
      wrap :one do
        step :two
      end

      def one(ctx, **)
        ctx[:one] = yield
      end

      def two(ctx, value:, **)
        ctx[:two] = value
      end
    end
  end

  let(:params) { { value: true } }
  let(:result) { klass.call(params) }

  it 'invokes wrap "one"' do
    expect(result[:one]).to be(true)
  end

  it 'succeeds' do
    expect(result).to be_success
  end

  it 'invokes Yaso::Logic::Classic only twice (Service and wrapper)' do
    allow(Yaso::Logic::Classic).to receive(:call).and_call_original
    2.times { klass.call(params) }
    expect(Yaso::Logic::Classic).to have_received(:call).twice
  end

  context 'when wrap fails' do
    let(:params) { { value: false } }

    it 'invokes wrap "one"' do
      expect(result[:one]).to be(false)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when next step exists' do
    subject(:klass) do
      create_service do
        wrap :one do
          step :two
        end
        step :three

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    it 'invokes step "three"' do
      expect(result[:three]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next step exists and wrap fails' do
    subject(:klass) do
      create_service do
        wrap :one do
          step :two
        end
        step :three

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'does not invoke step "three"' do
      expect(result[:three]).to be_nil
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when next step exists and wrap is fast: true' do
    subject(:klass) do
      create_service do
        wrap :one, fast: true do
          step :two
        end
        step :three

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    it 'does not invoke step "three"' do
      expect(result[:three]).to be_nil
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next step exists and wrap is fast: :success' do
    subject(:klass) do
      create_service do
        wrap :one, fast: :success do
          step :two
        end
        step :three

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    it 'does not invoke step "three"' do
      expect(result[:three]).to be_nil
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next failure exists and wrap fails' do
    subject(:klass) do
      create_service do
        wrap :one do
          step :two
        end
        failure :three

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'invokes failure "three"' do
      expect(result[:three]).to be(true)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when next failure exists and wrap is fast: true' do
    subject(:klass) do
      create_service do
        wrap :one, fast: true do
          step :two
        end
        failure :three

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'does not invoke failure "three"' do
      expect(result[:three]).to be_nil
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when next failure exists and wrap is fast: :failure' do
    subject(:klass) do
      create_service do
        wrap :one, fast: :failure do
          step :two
        end
        failure :three

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'does not invoke failure "three"' do
      expect(result[:three]).to be_nil
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when next failure exists and wrap succeeds' do
    subject(:klass) do
      create_service do
        wrap :one do
          step :two
        end
        failure :three

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    it 'does not invoke failure "three"' do
      expect(result[:three]).to be_nil
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next step and failure exist' do
    subject(:klass) do
      create_service do
        wrap :one do
          step :two
        end
        step :three
        failure :four

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    it 'invokes step "three"' do
      expect(result[:three]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next step and failure exist and wrap fails' do
    subject(:klass) do
      create_service do
        wrap :one do
          step :two
        end
        step :three
        failure :four

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'does not invoke step "three"' do
      expect(result[:three]).to be_nil
    end

    it 'invokes failure "four"' do
      expect(result[:four]).to be(true)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when wrap has on_success' do
    subject(:klass) do
      create_service do
        wrap :one, on_success: :four do
          step :two
        end
        step :three
        step :four

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    it 'does not invoke step "three"' do
      expect(result[:three]).to be_nil
    end

    it 'invokes step "four"' do
      expect(result[:four]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when wrap has on_success to failure' do
    subject(:klass) do
      create_service do
        wrap :one, on_success: :four do
          step :two
        end
        step :three
        failure :four

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    it 'does not invoke step "three"' do
      expect(result[:three]).to be_nil
    end

    it 'invokes failure "four"' do
      expect(result[:four]).to be(true)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when wrap has on_success to undefined step' do
    subject(:klass) do
      create_service do
        wrap :one, on_success: :four do
          step :two
        end
        step :three

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    it 'raises StepIsNotImplementedError' do
      expect { result }.to raise_error(Yaso::StepIsNotImplementedError)
    end
  end

  context 'when step has on_failure' do
    subject(:klass) do
      create_service do
        wrap :one, on_failure: :four do
          step :two
        end
        step :three
        failure :four

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'does not invoke step "three"' do
      expect(result[:three]).to be_nil
    end

    it 'invokes failure "four"' do
      expect(result[:four]).to be(true)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when wrap has on_failure to step' do
    subject(:klass) do
      create_service do
        wrap :one, on_failure: :four do
          step :two
        end
        step :three
        step :four

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'does not invoke step "three"' do
      expect(result[:three]).to be_nil
    end

    it 'invokes step "four"' do
      expect(result[:four]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when step has on_failure to undefined step' do
    subject(:klass) do
      create_service do
        wrap :one, on_failure: :four do
          step :two
        end
        step :three

        def one(ctx, **)
          ctx[:one] = yield
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    it 'raises StepIsNotImplementedError' do
      expect { result }.to raise_error(Yaso::StepIsNotImplementedError)
    end
  end

  context 'when step is a callable' do
    subject(:klass) do
      create_service do
        wrap CallableClass do
          step :two
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end
      end
    end

    before do
      constant = Class.new do
        def self.call(ctx, **)
          ctx[:one] = yield
        end
      end
      stub_const('CallableClass', constant)
    end

    it 'invokes constant' do
      expect(result[:one]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when step is a callable and has a name' do
    subject(:klass) do
      create_service do
        step :one, on_failure: :three
        step :two
        wrap CallableClass, name: :three do
          step :four
        end

        def one(ctx, **)
          ctx[:one] = false
        end

        def two(ctx, **)
          ctx[:two] = true
        end

        def four(ctx, value:, **)
          ctx[:four] = value
        end
      end
    end

    before do
      constant = Class.new do
        def self.call(ctx, **)
          ctx[:three] = yield
        end
      end
      stub_const('CallableClass', constant)
    end

    it 'invokes constant' do
      expect(result[:three]).to be(true)
    end

    it 'does not invoke step "two"' do
      expect(result[:two]).to be_nil
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end
end
