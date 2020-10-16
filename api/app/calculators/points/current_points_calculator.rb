module Points
  class CurrentPointsCalculator
    class << self
      def call(user)
        response(gained_points(user), spent_points(user), lossings(user), winnings(user), user)
      end

      def gained_points(user)
        user.rewards.pluck(:points).sum
      end

      def spent_points(user)
        user
          .ticket_discounts.active
          .includes(:discount)
          .pluck(:'ticket_discounts.original_cost', :'discounts.cost')
          .map(&method(:map_discount)).sum
      end

      def current_points(user)
        [0, total_points(user)].max
      end

      def deficit?(user)
        total_points(user).negative?
      end

      def point_deficit(user)
        -[0, total_points(user)].min
      end

      def lossings(user)
        user.rewards.where('points < 0').pluck(:points).sum.abs
      end

      def winnings(user)
        user.rewards.where('points >= 0').pluck(:points).sum
      end

      private

      def total_points(user)
        gained_points(user) - spent_points(user)
      end

      def map_discount(discount)
        discount.find(&:present?).presence || 0
      end

      def response(gained_points, spent_points, lossings, winnings, user)
        {
          data: {
            user_id: user.id,
            attributes: {
              current_points: current_points(user),
              total_gained_points: gained_points, total_spent_points: spent_points,
              lost_points: lossings, gained_points: winnings, deficit: point_deficit(user)
            }
          }
        }.to_json
      end
    end
  end
end
