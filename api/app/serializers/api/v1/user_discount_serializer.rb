module Api
  module V1
    class UserDiscountSerializer < ApiSerializer
      belongs_to :discount, serializer: Api::V1::DiscountSerializer
    end
  end
end
