class SaveRegistrationRewardPoints
  include Interactor

  def call
    build_record(context)
    return unless @reward.save!

    context.points = @reward.points
  end

  private

  def fetch_points
    Rails.application.secrets.registration_reward_points
  end

  def build_record(context)
    @reward = Reward.new(
      user: context.user,
      points: fetch_points,
      concept: I18n.t('reward.concepts.registration_reward')
    )
  end
end
