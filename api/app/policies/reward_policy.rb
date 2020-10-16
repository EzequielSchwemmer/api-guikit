class RewardPolicy < AdminPolicy
  def index?
    false
  end

  def new?
    create?
  end

  def create?
    user.allows? :send_custom_rewards
  end
end
