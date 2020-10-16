module Api
  module V1
    class UserDiscountsController < ApiController
      include RenderPaginated

      def index
        # Yes this query could be solved as current_user.discounts.running alone,
        # But to keep the old api intact, it ended up looking like these.
        # TODO: For MVP2 and future versions, please, use HABTM releationship without fear.
        discounts = current_user.user_discounts_without_exchange
                                .where(discount: current_user.discounts.running)
        render_paginated discounts,
                         included_models: [:discount],
                         serializer: Api::V1::UserDiscountSerializer,
                         params: { current_user: current_user },
                         per_page: 20
      end

      def obtained_discounts
        discounts = current_user.ticket_discounts.includes(:discount, :ticket)
        render_paginated discounts,
                         serializer: Api::V1::ObtainedDiscountSerializer,
                         per_page: 20
      end
    end
  end
end
