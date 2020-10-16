module Api
  module V1
    class DiscountsController < ApiController
      skip_before_action :authenticate_user!, only: [:landing_discounts]
      def landing_discounts
        result = RandomDiscounts.call
        render json: Api::V1::LandingDiscountSerializer.new(result.discounts)
      end

      def show
        render json: Api::V1::DiscountSerializer.new(
          discount, params: { current_user: current_user }
        )
      end

      private

      def discount
        @discount ||= Discount.running.find(params.require(:id))
      end
    end
  end
end
