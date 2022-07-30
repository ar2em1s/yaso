# frozen_string_literal: true

RSpec.describe 'Errors' do
  describe Yaso::StepIsNotImplementedError do
    subject(:error) { described_class.new(klass, step) }

    let(:klass) { FFaker::Lorem.word }
    let(:step) { FFaker::Lorem.word }

    it { expect(error.message).to eq "#{klass}##{step} step is not implemented" }
  end

  describe Yaso::InvalidFirstStepError do
    subject(:error) { described_class.new(category) }

    let(:category) { FFaker::Lorem.word }

    it { expect(error.message).to eq "#{category.capitalize} cannot be the first step" }
  end

  describe Yaso::UnhandledSwitchCaseError do
    subject(:error) { described_class.new(klass) }

    let(:klass) { FFaker::Lorem.word }

    it { expect(error.message).to eq "Unhandled switch case in #{klass}" }
  end
end
