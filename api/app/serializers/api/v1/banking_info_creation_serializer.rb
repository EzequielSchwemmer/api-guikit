module Api
  module V1
    class BankingInfoCreationSerializer < BankingInfoSerializer
      attribute :gained_points do
        Rails.application.secrets.banking_info_reward_points
      end
    end
  end
end
