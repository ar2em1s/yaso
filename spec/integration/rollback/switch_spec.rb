RSpec.describe "Switch", flow: :rollback, type: :integration do
  subject(:klass) do
    create_service do
      switch :one, key: :value, cases: {true => :two, false => :three}

      def two(ctx, **)
        ctx[:two] = true
      end

      def three(ctx, **)
        ctx[:three] = false
      end
    end
  end

  let(:params) { {value: true} }
  let(:result) { klass.call(params) }

  it 'invokes step "two"' do
    expect(result[:two]).to be(true)
  end

  it "succeeds" do
    expect(result).to be_success
  end

  context "when switch case fails" do
    let(:params) { {value: false} }

    it 'invokes step "three"' do
      expect(result[:three]).to be(false)
    end

    it "fails" do
      expect(result).to be_failure
    end
  end

  context "when switch case is unhandled" do
    let(:params) { {value: nil} }

    it "raises Yaso::UnhandledSwitchCaseError" do
      expect { result }.to raise_error(Yaso::UnhandledSwitchCaseError)
    end
  end

  context "when next step exists" do
    subject(:klass) do
      create_service do
        switch :one, key: :value, cases: {true => :two, false => :three}
        step :four

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    it 'invokes step "four"' do
      expect(result[:four]).to be(true)
    end

    it "succeeds" do
      expect(result).to be_success
    end
  end

  context "when next step exists and switch fails" do
    subject(:klass) do
      create_service do
        switch :one, key: :value, cases: {true => :two, false => :three}
        step :four

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    let(:params) { {value: false} }

    it 'does not invoke step "four"' do
      expect(result[:four]).to be_nil
    end

    it "fails" do
      expect(result).to be_failure
    end
  end

  context "when next step exists and switch is fast: true" do
    subject(:klass) do
      create_service do
        switch :one, fast: true, key: :value, cases: {true => :two, false => :three}
        step :four

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    it 'does not invoke step "four"' do
      expect(result[:four]).to be_nil
    end

    it "succeeds" do
      expect(result).to be_success
    end
  end

  context "when next step exists and switch is fast: :success" do
    subject(:klass) do
      create_service do
        switch :one, fast: :success, key: :value, cases: {true => :two, false => :three}
        step :four

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    it 'does not invoke step "four"' do
      expect(result[:four]).to be_nil
    end

    it "succeeds" do
      expect(result).to be_success
    end
  end

  context "when next failure exists and switch fails" do
    subject(:klass) do
      create_service do
        failure :four
        switch :one, key: :value, cases: {true => :two, false => :three}

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    let(:params) { {value: false} }

    it 'invokes failure "four"' do
      expect(result[:four]).to be(true)
    end

    it "fails" do
      expect(result).to be_failure
    end
  end

  context "when next failure exists and switch is fast: true" do
    subject(:klass) do
      create_service do
        failure :four
        switch :one, fast: true, key: :value, cases: {true => :two, false => :three}

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    let(:params) { {value: false} }

    it 'does not invoke failure "four"' do
      expect(result[:four]).to be_nil
    end

    it "fails" do
      expect(result).to be_failure
    end
  end

  context "when next failure exists and switch is fast: :failure" do
    subject(:klass) do
      create_service do
        failure :four
        switch :one, fast: :failure, key: :value, cases: {true => :two, false => :three}

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    let(:params) { {value: false} }

    it 'does not invoke failure "four"' do
      expect(result[:four]).to be_nil
    end

    it "fails" do
      expect(result).to be_failure
    end
  end

  context "when next failure exists and switch succeeds" do
    subject(:klass) do
      create_service do
        failure :four
        switch :one, key: :value, cases: {true => :two, false => :three}

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    it 'does not invoke failure "four"' do
      expect(result[:four]).to be_nil
    end

    it "succeeds" do
      expect(result).to be_success
    end
  end

  context "when next step and failure exist" do
    subject(:klass) do
      create_service do
        failure :five
        switch :one, key: :value, cases: {true => :two, false => :three}
        step :four

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end

        def five(ctx, **)
          ctx[:five] = true
        end
      end
    end

    it 'invokes step "four"' do
      expect(result[:four]).to be(true)
    end

    it "succeeds" do
      expect(result).to be_success
    end
  end

  context "when next step and failure exist and switch fails" do
    subject(:klass) do
      create_service do
        failure :five
        switch :one, key: :value, cases: {true => :two, false => :three}
        step :four

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end

        def five(ctx, **)
          ctx[:five] = true
        end
      end
    end

    let(:params) { {value: false} }

    it 'does not invoke step "four"' do
      expect(result[:four]).to be_nil
    end

    it 'invokes failure "five"' do
      expect(result[:five]).to be(true)
    end

    it "fails" do
      expect(result).to be_failure
    end
  end

  context "when switch has on_success" do
    subject(:klass) do
      create_service do
        switch :one, on_success: :five, key: :value, cases: {true => :two, false => :three}
        step :four
        step :five

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end

        def five(ctx, **)
          ctx[:five] = true
        end
      end
    end

    it 'does not invoke step "four"' do
      expect(result[:four]).to be_nil
    end

    it 'invokes step "five"' do
      expect(result[:five]).to be(true)
    end

    it "succeeds" do
      expect(result).to be_success
    end
  end

  context "when switch has on_success to failure" do
    subject(:klass) do
      create_service do
        switch :one, on_success: :five, key: :value, cases: {true => :two, false => :three}
        failure :five
        step :four

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end

        def five(ctx, **)
          ctx[:five] = true
        end
      end
    end

    it 'does not invoke step "four"' do
      expect(result[:four]).to be_nil
    end

    it 'invokes failure "five"' do
      expect(result[:five]).to be(true)
    end

    it "fails" do
      expect(result).to be_failure
    end
  end

  context "when switch has on_success to undefined step" do
    subject(:klass) do
      create_service do
        switch :one, on_success: :four, key: :value, cases: {true => :two, false => :three}

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end
      end
    end

    it "raises StepIsNotImplementedError" do
      expect { result }.to raise_error(Yaso::StepIsNotImplementedError)
    end
  end

  context "when switch has on_failure" do
    subject(:klass) do
      create_service do
        switch :one, on_failure: :five, key: :value, cases: {true => :two, false => :three}
        failure :five
        step :four

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end

        def five(ctx, **)
          ctx[:five] = true
        end
      end
    end

    let(:params) { {value: false} }

    it 'does not invoke step "four"' do
      expect(result[:four]).to be_nil
    end

    it 'invokes failure "five"' do
      expect(result[:five]).to be(true)
    end

    it "fails" do
      expect(result).to be_failure
    end
  end

  context "when switch has on_failure to step" do
    subject(:klass) do
      create_service do
        switch :one, on_failure: :five, key: :value, cases: {true => :two, false => :three}
        step :four
        step :five

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end

        def four(ctx, **)
          ctx[:four] = true
        end

        def five(ctx, **)
          ctx[:five] = true
        end
      end
    end

    let(:params) { {value: false} }

    it 'does not invoke step "four"' do
      expect(result[:four]).to be_nil
    end

    it 'invokes step "five"' do
      expect(result[:five]).to be(true)
    end

    it "succeeds" do
      expect(result).to be_success
    end
  end

  context "when switch has on_failure to undefined step" do
    subject(:klass) do
      create_service do
        switch :one, on_failure: :four, key: :value, cases: {true => :two, false => :three}

        def two(ctx, **)
          ctx[:two] = true
        end

        def three(ctx, **)
          ctx[:three] = false
        end
      end
    end

    it "raises StepIsNotImplementedError" do
      expect { result }.to raise_error(Yaso::StepIsNotImplementedError)
    end
  end

  context "when switch is hidden" do
    subject(:klass) do
      create_service do
        switch :one, key: :value, cases: {true => :two}

        def two(ctx, **)
          ctx[:two] = true
        end
      end
    end

    it 'invokes step "two"' do
      expect(result[:two]).to be(true)
    end

    it "succeeds" do
      expect(result).to be_success
    end

    context "when unhandled case happens" do
      let(:params) { {value: false} }

      it "raises Yaso::UnhandledSwitchCaseError" do
        expect { result }.to raise_error(Yaso::UnhandledSwitchCaseError)
      end
    end
  end

  context "when switch is inline" do
    subject(:klass) do
      create_service do
        switch(:one) { |_, value:, **| {true => :two}[value] }

        def two(ctx, **)
          ctx[:two] = true
        end
      end
    end

    it 'invokes step "two"' do
      expect(result[:two]).to be(true)
    end

    it "succeeds" do
      expect(result).to be_success
    end

    context "when unhandled case happens" do
      let(:params) { {value: false} }

      it "raises Yaso::UnhandledSwitchCaseError" do
        expect { result }.to raise_error(Yaso::UnhandledSwitchCaseError)
      end
    end
  end

  context "when switch is callable" do
    subject(:klass) do
      create_service do
        switch CallableClass

        def two(ctx, **)
          ctx[:two] = true
        end
      end
    end

    before do
      constant = Class.new do
        def self.call(ctx, **)
          {true => :two}[ctx[:value]]
        end
      end
      stub_const("CallableClass", constant)
    end

    it 'invokes step "two"' do
      expect(result[:two]).to be(true)
    end

    it "succeeds" do
      expect(result).to be_success
    end

    context "when unhandled case happens" do
      let(:params) { {value: false} }

      it "raises Yaso::UnhandledSwitchCaseError" do
        expect { result }.to raise_error(Yaso::UnhandledSwitchCaseError)
      end
    end
  end

  context "when switch is callable and has a name" do
    subject(:klass) do
      create_service do
        step :one, on_failure: :three
        step :two
        switch CallableClass, name: :three

        def one(ctx, **)
          ctx[:one] = false
        end

        def two(ctx, **)
          ctx[:two] = true
        end

        def four(ctx, **)
          ctx[:four] = true
        end
      end
    end

    before do
      constant = Class.new do
        def self.call(ctx, **)
          {true => :four}[ctx[:value]]
        end
      end
      stub_const("CallableClass", constant)
    end

    it 'does not invoke step "two"' do
      expect(result[:two]).to be_nil
    end

    it 'invokes step "four"' do
      expect(result[:four]).to be(true)
    end

    it "succeeds" do
      expect(result).to be_success
    end
  end

  context "when switch case is a callable" do
    subject(:klass) do
      create_service do
        switch :one, key: :value, cases: {true => CallableClass}
      end
    end

    before do
      constant = Class.new do
        def self.call(ctx, **)
          ctx[:two] = true
        end
      end
      stub_const("CallableClass", constant)
    end

    it "invokes constant" do
      expect(result[:two]).to be(true)
    end

    it "succeeds" do
      expect(result).to be_success
    end
  end

  context "when switch case is a Yaso::Service" do
    subject(:klass) do
      create_service do
        switch :one, key: :value, cases: {true => YasoServiceClass}
      end
    end

    before do
      constant = create_service do
        step(:two) { |ctx, **| ctx[:two] = true }
      end
      stub_const("YasoServiceClass", constant)
    end

    it "invokes constant" do
      expect(result[:two]).to be(true)
    end

    it "succeeds" do
      expect(result).to be_success
    end
  end
end
