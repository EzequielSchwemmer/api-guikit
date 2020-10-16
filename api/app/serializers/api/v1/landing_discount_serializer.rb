module Api
  module V1
    class LandingDiscountSerializer < ApiSerializer
      attribute :title, :description, :product_description, :discount_type

      attribute :picture do |object|
        Rails.application.routes.url_helpers.rails_representation_url(
          object.picture_variant(:thumbnail)
        )
      end
    end
  end
end
