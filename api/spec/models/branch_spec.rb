describe Branch do
  subject(:branch) { build_stubbed(:branch) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to belong_to(:retailer) }

  context 'when a branch without a name is created' do
    subject(:branch) { build(:branch, name: nil) }

    it { is_expected.not_to be_valid }
  end

  context 'when a branch without a retailer is created' do
    subject(:branch) { build(:branch, retailer: nil) }

    it { is_expected.not_to be_valid }
  end
end
