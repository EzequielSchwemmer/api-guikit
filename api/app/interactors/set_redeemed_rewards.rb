class SetRedeemedRewards
  include Interactor

  delegate :user, to: :context

  def call
    redeemed_rewards = []
    ticket_discounts.map do |ticket_discount|
      redeemed_rewards << user.rewards.new(
        points: ticket_discount.discount.cost * -1,
        concept: I18n.t('reward.concepts.redeemed_ticket'),
        created_at: ticket_discount.created_at
      )
    end
    context.redeemed_rewards = redeemed_rewards
  end

  private

  def ticket_discounts
    user.ticket_discounts.active.includes(:discount)
  end
end
