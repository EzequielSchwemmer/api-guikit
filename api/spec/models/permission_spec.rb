describe Permission do
  subject(:permission) { described_class.find_or_create_by(attributes_for(:permission)) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:code) }

  context 'when a role does not have a name' do
    subject(:permission) { build(:permission, code: nil) }

    it { is_expected.not_to be_valid }
  end
end
