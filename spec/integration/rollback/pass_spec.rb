# frozen_string_literal: true

RSpec.describe 'Pass', flow: :rollback, type: :integration do
  subject(:klass) do
    create_service do
      pass :one

      def one(ctx, value:, **)
        ctx[:one] = value
      end
    end
  end

  let(:params) { { value: true } }
  let(:result) { klass.call(params) }

  it 'invokes pass "one"' do
    expect(result[:one]).to be(true)
  end

  it 'succeeds' do
    expect(result).to be_success
  end

  context 'when pass fails' do
    let(:params) { { value: false } }

    it 'invokes pass "one"' do
      expect(result[:one]).to be(false)
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next pass exists' do
    subject(:klass) do
      create_service do
        pass :one
        step :two

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end
      end
    end

    it 'invokes step "two"' do
      expect(result[:two]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next step exists and pass fails' do
    subject(:klass) do
      create_service do
        pass :one
        step :two

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'invokes step "two"' do
      expect(result[:two]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next step exists and pass is fast: true' do
    subject(:klass) do
      create_service do
        pass :one, fast: true
        step :two

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end
      end
    end

    it 'does not invoke step "two"' do
      expect(result[:two]).to be_nil
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next step exists and pass is fast: :success' do
    subject(:klass) do
      create_service do
        step :one, fast: :success
        step :two

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end
      end
    end

    it 'does not invoke step "two"' do
      expect(result[:two]).to be_nil
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next failure exists and pass fails' do
    subject(:klass) do
      create_service do
        failure :two
        pass :one

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'does not invoke failure "two"' do
      expect(result[:two]).to be_nil
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next failure exists and pass is fast: true' do
    subject(:klass) do
      create_service do
        failure :two
        pass :one, fast: true

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'does not invoke failure "two"' do
      expect(result[:two]).to be_nil
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next failure exists and pass is fast: :failure' do
    subject(:klass) do
      create_service do
        failure :two
        pass :one, fast: :failure

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'does not invoke failure "two"' do
      expect(result[:two]).to be_nil
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next failure exists and pass succeeds' do
    subject(:klass) do
      create_service do
        failure :two
        pass :one

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end
      end
    end

    it 'does not invoke failure "two"' do
      expect(result[:two]).to be_nil
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next step and failure exist' do
    subject(:klass) do
      create_service do
        failure :three
        pass :one
        step :two

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    it 'invokes step "two"' do
      expect(result[:two]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when next step and failure exist and pass fails' do
    subject(:klass) do
      create_service do
        failure :three
        pass :one
        step :two

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'invokes step "two"' do
      expect(result[:two]).to be(true)
    end

    it 'does not invoke failure "three"' do
      expect(result[:three]).to be_nil
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when pass has on_success' do
    subject(:klass) do
      create_service do
        pass :one, on_success: :three
        step :two
        step :three

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    it 'does not invoke step "two"' do
      expect(result[:two]).to be_nil
    end

    it 'invokes step "three"' do
      expect(result[:three]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when pass has on_success to failure' do
    subject(:klass) do
      create_service do
        pass :one, on_success: :three
        failure :three
        step :two

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    it 'does not invoke step "two"' do
      expect(result[:two]).to be_nil
    end

    it 'invokes failure "three"' do
      expect(result[:three]).to be(true)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when pass has on_success to undefined step' do
    subject(:klass) do
      create_service do
        step :one, on_success: :two

        def one(ctx, value:, **)
          ctx[:one] = value
        end
      end
    end

    it 'raises StepIsNotImplementedError' do
      expect { result }.to raise_error(Yaso::StepIsNotImplementedError)
    end
  end

  context 'when pass has on_failure' do
    subject(:klass) do
      create_service do
        pass :one, on_failure: :three
        failure :three
        step :two

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'does not invoke step "two"' do
      expect(result[:two]).to be_nil
    end

    it 'invokes failure "three"' do
      expect(result[:three]).to be(true)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when pass has on_failure to step' do
    subject(:klass) do
      create_service do
        pass :one, on_failure: :three
        step :two
        step :three

        def one(ctx, value:, **)
          ctx[:one] = value
        end

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    let(:params) { { value: false } }

    it 'does not invoke step "two"' do
      expect(result[:two]).to be_nil
    end

    it 'invokes step "three"' do
      expect(result[:three]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when pass has on_failure to undefined step' do
    subject(:klass) do
      create_service do
        pass :one, on_failure: :two

        def one(ctx, value:, **)
          ctx[:one] = value
        end
      end
    end

    it 'raises StepIsNotImplementedError' do
      expect { result }.to raise_error(Yaso::StepIsNotImplementedError)
    end
  end

  context 'when pass is inline' do
    subject(:klass) do
      create_service do
        pass(:one) { |ctx, value:, **| ctx[:one] = value }
      end
    end

    it 'invokes pass "one"' do
      expect(result[:one]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when pass is inline and block is not passed' do
    subject(:klass) do
      create_service do
        pass(:one)
      end
    end

    it 'raises StepIsNotImplementedError' do
      expect { result }.to raise_error(Yaso::StepIsNotImplementedError)
    end
  end

  context 'when pass is a callable' do
    subject(:klass) do
      create_service do
        pass CallableClass
      end
    end

    before do
      constant = Class.new do
        def self.call(ctx, **)
          ctx[:one] = ctx[:value]
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

  context 'when pass is a callable and has a name' do
    subject(:klass) do
      create_service do
        step :one, on_failure: :three
        step :two
        pass CallableClass, name: :three

        def one(ctx, **)
          ctx[:one] = false
        end

        def two(ctx, **)
          ctx[:two] = true
        end
      end
    end

    before do
      constant = Class.new do
        def self.call(ctx, **)
          ctx[:three] = true
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

  context 'when pass is a Yaso::Service' do
    subject(:klass) do
      create_service do
        pass YasoServiceClass
      end
    end

    before do
      constant = create_service do
        step(:one) { |ctx, value:, **| ctx[:one] = value }
      end
      stub_const('YasoServiceClass', constant)
    end

    it 'invokes constant' do
      expect(result[:one]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end
  end

  context 'when pass is a Yaso::Service and has a name' do
    subject(:klass) do
      create_service do
        step :one, on_failure: :three
        step :two
        pass YasoServiceClass, name: :three

        def one(ctx, **)
          ctx[:one] = false
        end

        def two(ctx, **)
          ctx[:two] = true
        end
      end
    end

    before do
      constant = create_service do
        step(:three) { |ctx, **| ctx[:three] = true }
      end
      stub_const('YasoServiceClass', constant)
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
