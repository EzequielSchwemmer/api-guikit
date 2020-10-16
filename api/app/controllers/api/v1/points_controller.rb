module Api
  module V1
    class PointsController < ApiController
      include RenderPaginated

      def current_points
        current_points = Points::CurrentPointsCalculator.call(current_user)
        render json: current_points, status: :ok
      end

      def history
        redeemed_rewards = SetRedeemedRewards.call(user: current_user)
        all_rewards = current_user.rewards.concat(redeemed_rewards['redeemed_rewards'])
        render_paginated all_rewards.order(created_at: :desc),
                         serializer: Api::V1::RewardSerializer,
                         per_page: 20
        CleanRedeemedRewards.call(redeemed_rewards: redeemed_rewards['redeemed_rewards'])
      end
    end
  end
end
