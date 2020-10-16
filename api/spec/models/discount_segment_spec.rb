describe DiscountSegment do
  subject(:discount_segment) { create(:discount_segment) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:segment) }
  it { is_expected.to validate_presence_of(:discount) }
end
