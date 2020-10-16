FactoryBot.define do
  factory :purchased_products_by_user do
    association :user
    association :product
  end
end
