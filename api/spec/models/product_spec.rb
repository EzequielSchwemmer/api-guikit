describe Product do
  subject(:product) { create(:product) }

  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
end
