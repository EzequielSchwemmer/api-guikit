describe Reward do
  subject(:reward) { build_stubbed(:reward, :with_user) }

  it { is_expected.to be_valid }

  it do
    expect(reward).to(
      validate_numericality_of(:points)
        .is_less_than_or_equal_to(Rails.application.secrets.boost_points_limit)
    )
  end
end
