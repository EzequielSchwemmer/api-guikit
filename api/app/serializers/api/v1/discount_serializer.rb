module Api
  module V1
    class DiscountSerializer < ApiSerializer
      attribute :title, :description, :product_description, :discount_type, :cost,
                :starts_at, :ends_at, :active, :terms_and_conditions, :steps

      attribute :picture do |object|
        Rails.application.routes.url_helpers.rails_blob_url(object.picture)
      end

      attribute :current_points do |_object, params|
        current_points params[:current_user]
      end

      attribute :sufficient do |object, params|
        object.cost <= current_points(params[:current_user])
      end

      def self.current_points(current_user)
        Points::CurrentPointsCalculator.current_points(current_user)
      end
    end
  end
end
