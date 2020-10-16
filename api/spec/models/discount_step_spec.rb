describe DiscountStep do
  subject(:discount_step) { build(:discount_step, :with_discount) }

  it { is_expected.to validate_presence_of(:text) }
  it { is_expected.to validate_presence_of(:position) }
  it { is_expected.to validate_numericality_of(:position) }
  it { is_expected.to validate_uniqueness_of(:position).scoped_to(:discount_id).case_insensitive }
end
