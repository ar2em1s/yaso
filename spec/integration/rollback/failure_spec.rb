# frozen_string_literal: true

RSpec.describe 'Failure', flow: :rollback, type: :integration do
  subject(:klass) do
    create_service do
      failure :two
      step :one

      def one(ctx, value:, **)
        ctx[:one] = value
      end

      def two(ctx, **)
        ctx[:two] = true
      end
    end
  end

  let(:params) { { value: true } }
  let(:result) { klass.call(params) }

  it 'invokes step "one"' do
    expect(result[:one]).to be(true)
  end

  it 'does not invoke failure "two"' do
    expect(result[:two]).to be_nil
  end

  it 'succeeds' do
    expect(result).to be_success
  end

  context 'when step fails' do
    let(:params) { { value: false } }

    it 'invokes step "one"' do
      expect(result[:one]).to be(false)
    end

    it 'invokes failure "two"' do
      expect(result[:two]).to be(true)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when failure is the first step' do
    subject(:klass) do
      create_service do
        failure :one

        def one(ctx, **)
          ctx[:one] = true
        end
      end
    end

    it 'does not raise InvalidFirstStepError' do
      expect { result }.not_to raise_error(Yaso::InvalidFirstStepError)
    end
  end

  context 'when two failures' do
    subject(:klass) do
      create_service do
        failure :three
        failure :two
        step :one

        def one(ctx, **)
          ctx[:one] = false
        end

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    it 'invokes failure "two"' do
      expect(result[:two]).to be(true)
    end

    it 'invokes failure "three"' do
      expect(result[:three]).to be(true)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when two failures and failure has fast: true' do
    subject(:klass) do
      create_service do
        failure :three
        failure :two, fast: true
        step :one

        def one(ctx, **)
          ctx[:one] = false
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    it 'invokes failure "two"' do
      expect(result[:two]).to be(true)
    end

    it 'does not invoke failure "three"' do
      expect(result[:three]).to be_nil
    end

    context 'when failure fails' do
      let(:params) { { value: false } }

      it 'invokes failure "two"' do
        expect(result[:two]).to be(false)
      end

      it 'does not invoke failure "three"' do
        expect(result[:three]).to be_nil
      end
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when two failures and failure has fast: :success' do
    subject(:klass) do
      create_service do
        failure :three
        failure :two, fast: :success
        step :one

        def one(ctx, **)
          ctx[:one] = false
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    it 'invokes failure "two"' do
      expect(result[:two]).to be(true)
    end

    it 'does not invoke failure "three"' do
      expect(result[:three]).to be_nil
    end

    context 'when failure fails' do
      let(:params) { { value: false } }

      it 'invokes failure "two"' do
        expect(result[:two]).to be(false)
      end

      it 'invokes failure "three"' do
        expect(result[:three]).to be(true)
      end
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when two failures and failure has fast: :failure' do
    subject(:klass) do
      create_service do
        failure :three
        failure :two, fast: :failure
        step :one

        def one(ctx, **)
          ctx[:one] = false
        end

        def two(ctx, value:, **)
          ctx[:two] = value
        end

        def three(ctx, **)
          ctx[:three] = true
        end
      end
    end

    it 'invokes failure "two"' do
      expect(result[:two]).to be(true)
    end

    it 'invokes failure "three"' do
      expect(result[:three]).to be(true)
    end

    context 'when failure fails' do
      let(:params) { { value: false } }

      it 'invokes failure "two"' do
        expect(result[:two]).to be(false)
      end

      it 'does not invoke failure "three"' do
        expect(result[:three]).to be_nil
      end
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when step, failure, step' do
    subject(:klass) do
      create_service do
        step :one
        failure :two
        step :three

        def one(ctx, **)
          ctx[:one] = true
        end

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, value:, **)
          ctx[:three] = value
        end
      end
    end

    it 'does not invoke failure "two"' do
      expect(result[:two]).to be_nil
    end

    it 'invokes step "three"' do
      expect(result[:three]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end

    context 'when step "three" fails' do
      let(:params) { { value: false } }

      it 'invokes failure "two"' do
        expect(result[:two]).to be(true)
      end

      it 'invokes step "three"' do
        expect(result[:three]).to be(false)
      end

      it 'fails' do
        expect(result).to be_failure
      end
    end
  end

  context 'when failure has on_success' do
    subject(:klass) do
      create_service do
        failure :two, on_success: :four
        failure :three
        step :one
        step :four

        def one(ctx, **)
          ctx[:one] = false
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

    it 'invokes step "four"' do
      expect(result[:four]).to be(true)
    end

    it 'succeeds' do
      expect(result).to be_success
    end

    context 'when failure fails' do
      let(:params) { { value: false } }

      it 'invokes failure "three"' do
        expect(result[:three]).to be(true)
      end

      it 'does not invoke step "four"' do
        expect(result[:four]).to be_nil
      end

      it 'fails' do
        expect(result).to be_failure
      end
    end
  end

  context 'when failure has on_failure' do
    subject(:klass) do
      create_service do
        failure :two, on_failure: :three
        step :one
        step :three

        def one(ctx, **)
          ctx[:one] = false
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

    it 'fails' do
      expect(result).to be_failure
    end

    context 'when failure fails' do
      let(:params) { { value: false } }

      it 'invokes step "three"' do
        expect(result[:three]).to be(true)
      end

      it 'succeeds' do
        expect(result).to be_success
      end
    end
  end

  context 'when failure is inline' do
    subject(:klass) do
      create_service do
        failure(:two) { |ctx, value:, **| ctx[:two] = value }
        step(:one) { |ctx, **| ctx[:one] = false }
      end
    end

    it 'invokes step "one"' do
      expect(result[:two]).to be(true)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when failure is inline and block is not passed' do
    subject(:klass) do
      create_service do
        failure(:two)
        step(:one) { |ctx, **| ctx[:one] = false }
      end
    end

    it 'raises StepIsNotImplementedError' do
      expect { result }.to raise_error(Yaso::StepIsNotImplementedError)
    end
  end

  context 'when failure is a callable' do
    subject(:klass) do
      create_service do
        failure CallableClass
        step(:one) { |ctx, **| ctx[:one] = false }
      end
    end

    before do
      constant = Class.new do
        def self.call(ctx, **)
          ctx[:two] = ctx[:value]
        end
      end
      stub_const('CallableClass', constant)
    end

    it 'invokes constant' do
      expect(result[:two]).to be(true)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when failure is a callable and has a name' do
    subject(:klass) do
      create_service do
        step :one, on_success: :three
        failure CallableClass, name: :three
        step :two

        def one(ctx, **)
          ctx[:one] = true
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

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when failure is a Yaso::Service' do
    subject(:klass) do
      create_service do
        failure YasoServiceClass
        step(:one) { |ctx, **| ctx[:one] = false }
      end
    end

    before do
      constant = create_service do
        step(:two) { |ctx, value:, **| ctx[:two] = value }
      end
      stub_const('YasoServiceClass', constant)
    end

    it 'invokes constant' do
      expect(result[:two]).to be(true)
    end

    it 'fails' do
      expect(result).to be_failure
    end
  end

  context 'when failure is a Yaso::Service and has a name' do
    subject(:klass) do
      create_service do
        step :one, on_success: :three
        failure YasoServiceClass, name: :three
        step :two

        def one(ctx, **)
          ctx[:one] = true
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

    it 'fails' do
      expect(result).to be_failure
    end
  end
end
