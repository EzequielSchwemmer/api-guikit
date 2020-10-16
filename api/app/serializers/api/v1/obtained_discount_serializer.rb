module Api
  module V1
    class ObtainedDiscountSerializer < ApiSerializer
      attribute :created_at
      attribute :title do |object|
        object.discount.title
      end
      attribute :discount_type do |object|
        object.discount.discount_type
      end
      attribute :description do |object|
        object.discount.description
      end
      attribute :product_description do |object|
        object.discount.product_description
      end
      attribute :status do |object|
        return 'REJECTED'  unless object&.active?

        object.ticket.general_status
      end
      attribute :picture do |object|
        Rails.application.routes.url_helpers.rails_blob_url(object.discount.picture)
      end
    end
  end
end
