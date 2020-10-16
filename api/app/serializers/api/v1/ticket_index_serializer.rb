module Api
  module V1
    class TicketIndexSerializer < TicketSerializer
      attribute :created_at, :reason_message
      attribute :points do |object|
        object.reward&.points
      end
      attribute :discounts do |object|
        object.ticket_discounts.map do |ticket_discount|
          discount = ticket_discount.discount
          {
            title: discount.title,
            cost: discount.cost,
            picture: Rails.application.routes.url_helpers.rails_blob_url(discount.picture),
            description: discount.description,
            discount_type: discount.discount_type,
            product_description: discount.product_description,
            status: discount_status_for(object, ticket_discount),
            reject_reason: discount.active? ? nil : object.reject_reason
          }
        end
      end

      def self.discount_status_for(ticket, discount)
        return :rejected unless discount.active?
        return :approved if ticket.approved? || ticket.paid?

        :pending
      end
    end
  end
end
