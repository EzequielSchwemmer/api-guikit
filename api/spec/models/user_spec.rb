describe User, type: :model do
  subject(:user) { create(:user) }

  let(:failed_record) { build(:user, :with_errors) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }
  it { is_expected.to validate_presence_of(:birthday) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:gender) }
  it { is_expected.to validate_uniqueness_of(:dni).case_insensitive }
  it { expect(failed_record).to be_invalid }
  it { is_expected.to have_many(:tickets) }
  it { is_expected.to validate_numericality_of(:dni) }
end
