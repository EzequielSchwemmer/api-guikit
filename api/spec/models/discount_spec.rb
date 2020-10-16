describe Discount, type: :model do
  subject(:discount) { create(:discount, :with_steps, :with_picture) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:cost) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:discount_type) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:product_description) }
  it { is_expected.to validate_presence_of(:terms_and_conditions) }
  it { is_expected.to validate_presence_of(:starts_at) }
  it { is_expected.to validate_presence_of(:ends_at) }
  it { is_expected.to validate_length_of(:discount_type) }
  it { is_expected.to validate_length_of(:description) }
  it { is_expected.to validate_length_of(:title) }
  it { is_expected.to have_many(:steps) }

  context 'when the discount does not have any picture' do
    subject(:discount) { build(:discount, picture: nil) }

    it { is_expected.not_to be_valid }
  end

  context 'when the discount has errors' do
    subject(:discount) { build(:discount, :with_errors) }

    it { is_expected.not_to be_valid }
  end
end
