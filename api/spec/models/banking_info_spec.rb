describe BankingInfo, type: :model do
  subject(:banking_info) { create(:banking_info) }

  let(:failed_record) { build(:banking_info, :with_errors) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:bank_name) }
  it { is_expected.to validate_presence_of(:cuit) }
  it { is_expected.to validate_uniqueness_of(:user) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_length_of(:cuit) }
  it { is_expected.to validate_length_of(:bank_alias) }
  it { is_expected.to validate_uniqueness_of(:bank_alias) }
  it { is_expected.to validate_length_of(:cbu) }
  it { is_expected.to validate_numericality_of(:cbu) }
  it { is_expected.to validate_numericality_of(:cuit) }
  it { expect(failed_record).to be_invalid }

  context 'when nuser is not the bank holder' do
    let(:banking_info) { build_stubbed(:banking_info, :with_holder) }

    it { expect(banking_info).to validate_presence_of(:holder_name) }
  end

  context 'when user is the bank holder' do
    let(:banking_info) { build_stubbed(:banking_info, :without_holder) }

    it { expect(banking_info).not_to validate_presence_of(:holder_name) }
  end
end
