class StoreReward
  include Interactor

  delegate :reward, :current_user, to: :context

  def call
    reward.author = current_user
    reward.save!
  rescue StandardError => e
    context.fail!(error: e)
  end
end
