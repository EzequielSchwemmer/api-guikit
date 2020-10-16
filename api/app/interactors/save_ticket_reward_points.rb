class SaveTicketRewardPoints
  include Interactor

  delegate :ticket, to: :context

  def call
    Reward.create!(
      user: context.user,
      points: fetch_points,
      concept: I18n.t('reward.concepts.ticket_reward')
    )
  end

  private

  def fetch_points
    Rails.application.secrets.ticket_reward_points
  end
end
