describe UserDiscount, type: :model do
  subject(:user_discount) { create(:user_discount) }

  let(:failed_record) { build(:user_discount, :with_errors) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:discount) }
  it { expect(failed_record).to be_invalid }
end
