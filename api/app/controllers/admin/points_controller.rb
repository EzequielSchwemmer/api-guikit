module Admin
  class PointsController < Admin::ApplicationController
    def index
      authorize user, :show?
      render locals: {
        user: user,
        points: points,
        resources: rewards.page(params[:page]).per(records_per_page),
        page: Administrate::Page::Collection.new(nil, order: order)
      }
      CleanRedeemedRewards.call(redeemed_rewards: ticket_exchanges)
    end

    def export
      authorize user, :show?
      send_data rewards.to_csv, filename: "point_history-#{user.id}-#{DateTime.current}.csv"
      CleanRedeemedRewards.call(redeemed_rewards: ticket_exchanges)
    end

    private

    def points
      JSON.parse(Points::CurrentPointsCalculator.call(user))
          .dig('data', 'attributes')
          .symbolize_keys
    end

    def user
      @user ||= User.find(params.require(:user_id))
    end

    def rewards
      @rewards = user.rewards.concat(ticket_exchanges).order(created_at: :desc)
    end

    def ticket_exchanges
      @ticket_exchanges ||= SetRedeemedRewards.call(user: user).redeemed_rewards
    end
  end
end
