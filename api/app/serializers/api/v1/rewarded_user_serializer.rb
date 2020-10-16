module Api
  module V1
    class RewardedUserSerializer < UserSerializer
      attribute :gained_points do
        Rails.application.secrets.registration_reward_points
      end
    end
  end
end
