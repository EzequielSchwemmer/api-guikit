describe Retailer do
  subject(:retailer) { build_stubbed(:retailer) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:branches) }

  context 'when an invalid retailer is created' do
    subject(:branch) { build(:retailer, name: nil) }

    it { is_expected.not_to be_valid }
  end
end
