class CleanRedeemedRewards
  include Interactor

  delegate :redeemed_rewards, to: :context

  def call
    redeemed_rewards.map!(&:delete)
  end
end
