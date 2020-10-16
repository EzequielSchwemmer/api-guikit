class SaveBoostRewardPoints
  include Interactor

  def call
    return if points.zero?

    Reward.create!(
      user: user,
      ticket: ticket,
      points: gained_points,
      concept: concept
    )
  rescue StandardError
    context.fail!
  end

  private

  delegate :ticket, :points, to: :context
  delegate :user, to: :ticket

  def concept
    I18n.t("reward.concepts.#{points.positive? ? 'boosted_points' : 'penalized_reward'}")
  end

  def gained_points
    current_points = Points::CurrentPointsCalculator.current_points(user)
    if points.negative? && current_points < (points * -1)
      current_points * -1
    else
      points
    end
  end
end
