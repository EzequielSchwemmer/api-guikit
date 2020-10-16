describe UserSegment do
  subject(:user_segment) { create(:user_segment) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:segment) }
  it { is_expected.to validate_presence_of(:user) }
end
