describe Segment do
  subject(:segment) { create(:segment) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to have_and_belong_to_many(:discounts) }
  it { is_expected.to have_many(:user_segments) }
  it { is_expected.to have_many(:users) }
end
