RSpec.describe Yaso::Steps::Base do
  subject(:step) { described_class.new(name: name, invocable: nil, **options) }

  let(:name) { nil }
  let(:options) { {} }

  describe "#call" do
    let(:params) { [{}, instance_double(Yaso::Service)] }

    it "raises NotImplementedError" do
      expect { step.call(*params) }.to raise_error(NotImplementedError)
    end
  end

  describe "#add_next_step" do
    let(:next_step) { instance_double(described_class) }

    it "adds the next_step" do
      expect(step.add_next_step(next_step)).to eq(next_step)
    end

    context "when fast equals true" do
      let(:options) { {fast: true} }

      it "does not add the next_step" do
        expect(step.add_next_step(next_step)).to be_nil
      end
    end

    context "when fast equals :success" do
      let(:options) { {fast: :success} }

      it "does not add the next_step" do
        expect(step.add_next_step(next_step)).to be_nil
      end
    end
  end

  describe "#add_failure" do
    let(:failure) { instance_double(described_class) }

    it "adds the next_step" do
      expect(step.add_failure(failure)).to eq(failure)
    end

    context "when fast equals true" do
      let(:options) { {fast: true} }

      it "does not add the next_step" do
        expect(step.add_failure(failure)).to be_nil
      end
    end

    context "when fast equals :success" do
      let(:options) { {fast: :failure} }

      it "does not add the next_step" do
        expect(step.add_failure(failure)).to be_nil
      end
    end
  end
end
