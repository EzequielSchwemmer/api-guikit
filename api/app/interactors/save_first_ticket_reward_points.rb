class SaveFirstTicketRewardPoints
  include Interactor

  def call
    ticket = TicketManager.new(context.user, context.params).create!
    context.ticket = ticket
    return unless ticket.first_ticket

    Reward.create!(
      user: context.user,
      points: fetch_points,
      concept: I18n.t('reward.concepts.first_ticket_reward')
    )
  end

  private

  def fetch_points
    Rails.application.secrets.first_ticket_reward_points
  end
end
